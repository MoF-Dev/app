import * as functions from 'firebase-functions';
import * as admin from "firebase-admin";
import {handler} from "./normalizer/request";
import FieldValue = admin.firestore.FieldValue;

admin.initializeApp();

// // Start writing Firebase Functions
// // https://firebase.google.com/docs/functions/typescript
//
// export const helloWorld = functions.https.onRequest((request, response) => {
//  response.send("Hello from Firebase!");
// });

enum FriendsRelationship {
    Strangers = "strangers",
    Pending = "pending",
    Friends = "friends",
}

export const addFriend = functions.https.onRequest(handler("/:fid",
    async (req, res) => {
        const fid: string = req.params.fid;
        const db = admin.firestore();
        const ids = [fid, req.user.uid].sort();
        const idset = `${ids[0]}-${ids[1]}`;

        const tests: Promise<number>[] = [];
        {
            // friend must exist
            tests.push(db.collection("users").doc(fid).get()
                .then((friend) => {
                    if (friend.exists) {
                        return 0;
                    } else {
                        return 404;
                    }
                }));

            // must not already be in a relationship
            tests.push(admin.firestore().collection("friendships").doc(idset).get()
                .then((ship) => {
                    if (!ship.exists) return 0;
                    if (ship.get("relationship") === FriendsRelationship.Strangers) return 0;
                    if (ship.get("relationship") === FriendsRelationship.Pending
                        && ship.get("requester") === req.user.uid
                        && ship.get("target") === fid) return 0;
                    return 400;
                }));
        }
        const testResult = await new Stream(tests).filter((t) => t !== 0).first();
        if (testResult !== null) {
            res.writeHead(testResult);
            return;
        }

        const writes = [];
        writes.push(db.collection("friendships").doc(idset).create({
            relationship: FriendsRelationship.Pending,
            requester: req.user.uid,
            target: fid,
            created: FieldValue.serverTimestamp(),
        }));
        writes.push(db.collection("users").doc(req.user.uid).collection("friendRequestsSent")
            .doc(fid).create({ref: idset}));
        writes.push(db.collection("users").doc(fid).collection("friendRequestsReceived")
            .doc(req.user.uid).create({ref: idset}));
        Promise.all(writes).then(() => {
            res.writeHead(200);
        }).catch((e) => {
            console.error(e);
            res.writeHead(500);
        });
    }));

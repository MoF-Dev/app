import {https} from "firebase-functions";
import {auth} from "firebase-admin";
import * as express from "express";
import * as cors from "cors";
import * as cookieParser from "cookie-parser";
import {validateFirebaseIdToken} from "./middleware";

export interface Request extends https.Request {
    user: auth.DecodedIdToken;
}

// tslint:disable-next-line:no-empty-interface
export interface Response extends express.Response {
}

export type Handler = (req: Request, res: Response) => void;
type NativeHandler = (req: https.Request, res: express.Response) => void;

export function handler(path: string, hdl: Handler): NativeHandler {
    const app = express();
    app.use(cors({origin: true}));
    app.use(cookieParser());
    app.use(validateFirebaseIdToken);
    app.use(path, (req, res, _) => {
        // @ts-ignore
        hdl(req, res);
    });
    return app;
}

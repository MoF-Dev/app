class Stream<T> {
    public constructor(protected data: Promise<T | null>[] = []) {
    }

    public map<U>(mapper: (t: T) => U): Stream<U> {
        return new Stream(this.data.map((p) => p.then((resolved) => {
            if (resolved === null) {
                return null;
            } else {
                return mapper(resolved);
            }
        })));
    }

    public filter(check: (t: T) => boolean): Stream<T> {
        return new Stream(this.data.map((p) => p.then((resolved) => {
            if (resolved === null) {
                return null;
            }
            if (check(resolved)) {
                return resolved;
            }
            return null;
        })));
    }

    public first(): Promise<T | null> {
        return new Promise((resolve, reject) => {
            const errors = [];
            for (const p of this.data) {
                errors.push(p.then((r) => {
                    if (r !== null) {
                        resolve(r);
                    }
                    return;
                }));
            }
            Promise.all(errors).then(() => {
                return null;
            }).catch(reject);
        });
    }
}

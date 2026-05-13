import { app, initializeApp } from "../src/app";

export default async function handler(req: any, res: any) {
  await initializeApp();
  return app(req, res);
}

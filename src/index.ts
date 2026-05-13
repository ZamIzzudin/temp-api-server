import { config } from "./config";
import { app, initializeApp } from "./app";

const start = async () => {
  await initializeApp({ seedOnBoot: true });

  app.listen(config.port, () => {
    console.log(`api-server listening on http://localhost:${config.port}`);
  });
};

start().catch((error) => {
  console.error("Failed to start api-server", error);
  process.exit(1);
});

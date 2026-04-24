import { createServer } from "node:http";
import { createReadStream } from "node:fs";
import { extname, join, normalize } from "node:path";

const root = new URL(".", import.meta.url).pathname;
const port = Number(process.env.PORT || 4173);
const types = { ".html": "text/html; charset=utf-8", ".css": "text/css; charset=utf-8", ".js": "text/javascript; charset=utf-8" };

createServer((request, response) => {
  const url = new URL(request.url || "/", `http://localhost:${port}`);
  const requestedPath = url.pathname === "/" ? "/index.html" : url.pathname;
  const filePath = normalize(join(root, requestedPath));

  if (!filePath.startsWith(root)) {
    response.writeHead(403);
    response.end("Forbidden");
    return;
  }

  const stream = createReadStream(filePath);
  stream.on("open", () => {
    response.writeHead(200, { "Content-Type": types[extname(filePath)] || "application/octet-stream" });
    stream.pipe(response);
  });
  stream.on("error", () => {
    response.writeHead(404);
    response.end("Not found");
  });
}).listen(port, () => console.log(`FoodLens is running at http://localhost:${port}`));

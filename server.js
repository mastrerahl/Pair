const express = require("express");
const path = require("path");
const cors = require("cors");
const pairRouter = require("./router");

const app = express();
const PORT = process.env.PORT || 3000;

app.use(cors());
app.use(express.static(path.join(__dirname, "public")));
app.use("/", pairRouter);

app.listen(PORT, () => {
  console.log(`🚀 Rahl Quantum running on port ${PORT}`);
});

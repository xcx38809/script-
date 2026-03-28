const express = require("express");
const app = express();

app.use(express.json());

let keys = {
  "ABC123": { max: 1, users: [] },
  "XYZ789": { max: 1, users: [] }
};

app.post("/check", (req, res) => {
  const { key, userId } = req.body;

  if (!keys[key]) {
    return res.json({ success: false });
  }

  let data = keys[key];

  if (data.users.includes(userId)) {
    return res.json({ success: true });
  }

  if (data.users.length >= data.max) {
    return res.json({ success: false });
  }

  data.users.push(userId);
  return res.json({ success: true });
});

const PORT = process.env.PORT || 3000;
app.listen(PORT);

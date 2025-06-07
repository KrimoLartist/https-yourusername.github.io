<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8" />
  <title>Xscript Reveal</title>
  <style>
    body {
      background-color: #111;
      color: #0f0;
      font-family: monospace;
      text-align: center;
      padding-top: 40px;
    }
    h1 {
      color: #0f0;
    }
    #grid {
      display: grid;
      grid-template-columns: repeat(5, 60px);
      gap: 5px;
      justify-content: center;
      margin: 30px auto;
    }
    .cell {
      width: 60px;
      height: 60px;
      background-color: #222;
      border: 2px solid #0f0;
      display: flex;
      align-items: center;
      justify-content: center;
      font-size: 24px;
      color: #0f0;
      cursor: pointer;
    }
    .revealed.win {
      background-color: #0f0;
      color: #000;
    }
    .revealed.lose {
      background-color: #f00;
      color: #fff;
    }
    button {
      background-color: #0f0;
      color: #000;
      padding: 10px 20px;
      border: none;
      font-size: 16px;
      cursor: pointer;
      margin-top: 20px;
    }
  </style>
</head>
<body>
  <h1>Xscript - Reveal Squares</h1>
  <div id="grid"></div>
  <button onclick="reveal()">🔍 Reveal</button>

  <script>
    const grid = document.getElementById("grid");
    const size = 25;
    const winIndexes = [];

    function generate() {
      grid.innerHTML = "";
      for (let i = 0; i < size; i++) {
        const cell = document.createElement("div");
        cell.classList.add("cell");
        cell.dataset.index = i;
        grid.appendChild(cell);
      }

      // اختيار مربعات الفوز عشوائيًا
      winIndexes.length = 0;
      while (winIndexes.length < 5) {
        const rand = Math.floor(Math.random() * size);
        if (!winIndexes.includes(rand)) {
          winIndexes.push(rand);
        }
      }
    }

    function reveal() {
      const cells = document.querySelectorAll(".cell");
      cells.forEach((cell, index) => {
        if (winIndexes.includes(index)) {
          cell.classList.add("revealed", "win");
          cell.textContent = "✓";
        } else {
          cell.classList.add("revealed", "lose");
          cell.textContent = "✗";
        }
      });
    }

    generate();
  </script>
</body>
</html>

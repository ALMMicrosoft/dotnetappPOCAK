using System;
using System.Drawing;
using System.Windows.Forms;

namespace Calculator
{
    public class MainForm : Form
    {
        private CalculatorEngine calculator;
        private TextBox txtDisplay;
        private TextBox txtHistory;
        private string currentOperation = "";
        private double firstNumber = 0;
        private bool isOperationPerformed = false;

        public MainForm()
        {
            calculator = new CalculatorEngine();
            InitializeComponent();
        }

        private void InitializeComponent()
        {
            // Form settings
            this.Text = ".NET Framework Calculator";
            this.Size = new Size(400, 600);
            this.StartPosition = FormStartPosition.CenterScreen;
            this.FormBorderStyle = FormBorderStyle.FixedSingle;
            this.MaximizeBox = false;
            this.BackColor = Color.FromArgb(240, 240, 240);

            // Display TextBox
            txtDisplay = new TextBox
            {
                Location = new Point(20, 20),
                Size = new Size(340, 40),
                Font = new Font("Segoe UI", 20, FontStyle.Bold),
                TextAlign = HorizontalAlignment.Right,
                ReadOnly = true,
                Text = "0",
                BackColor = Color.White
            };
            this.Controls.Add(txtDisplay);

            // History TextBox
            txtHistory = new TextBox
            {
                Location = new Point(20, 70),
                Size = new Size(340, 30),
                Font = new Font("Segoe UI", 10),
                TextAlign = HorizontalAlignment.Right,
                ReadOnly = true,
                BackColor = Color.FromArgb(250, 250, 250),
                ForeColor = Color.Gray,
                BorderStyle = BorderStyle.None
            };
            this.Controls.Add(txtHistory);

            // Create buttons
            int buttonWidth = 70;
            int buttonHeight = 60;
            int spacing = 10;
            int startX = 20;
            int startY = 120;

            // Number buttons (0-9)
            string[,] buttonLayout = new string[,]
            {
                { "7", "8", "9", "/" },
                { "4", "5", "6", "*" },
                { "1", "2", "3", "-" },
                { "C", "0", "=", "+" }
            };

            for (int row = 0; row < 4; row++)
            {
                for (int col = 0; col < 4; col++)
                {
                    string buttonText = buttonLayout[row, col];
                    Button btn = CreateButton(
                        buttonText,
                        startX + (col * (buttonWidth + spacing)),
                        startY + (row * (buttonHeight + spacing)),
                        buttonWidth,
                        buttonHeight
                    );
                    this.Controls.Add(btn);
                }
            }

            // Special operation buttons (on the right side)
            Button btnPower = CreateButton("x^y", startX + (4 * (buttonWidth + spacing)), startY, buttonWidth, buttonHeight);
            Button btnSqrt = CreateButton("√", startX + (4 * (buttonWidth + spacing)), startY + (buttonHeight + spacing), buttonWidth, buttonHeight);
            Button btnDecimal = CreateButton(".", startX + (4 * (buttonWidth + spacing)), startY + (2 * (buttonHeight + spacing)), buttonWidth, buttonHeight);
            Button btnClear = CreateButton("CE", startX + (4 * (buttonWidth + spacing)), startY + (3 * (buttonHeight + spacing)), buttonWidth, buttonHeight);

            this.Controls.Add(btnPower);
            this.Controls.Add(btnSqrt);
            this.Controls.Add(btnDecimal);
            this.Controls.Add(btnClear);

            // Menu
            CreateMenu();
        }

        private Button CreateButton(string text, int x, int y, int width, int height)
        {
            Button btn = new Button
            {
                Text = text,
                Location = new Point(x, y),
                Size = new Size(width, height),
                Font = new Font("Segoe UI", 14, FontStyle.Bold),
                FlatStyle = FlatStyle.Flat,
                Cursor = Cursors.Hand
            };

            // Color scheme
            if (char.IsDigit(text[0]) || text == ".")
            {
                btn.BackColor = Color.White;
                btn.ForeColor = Color.Black;
            }
            else if (text == "C" || text == "CE")
            {
                btn.BackColor = Color.FromArgb(255, 69, 58);
                btn.ForeColor = Color.White;
            }
            else if (text == "=")
            {
                btn.BackColor = Color.FromArgb(52, 199, 89);
                btn.ForeColor = Color.White;
            }
            else
            {
                btn.BackColor = Color.FromArgb(0, 122, 255);
                btn.ForeColor = Color.White;
            }

            btn.FlatAppearance.BorderSize = 0;
            btn.Click += Button_Click;

            return btn;
        }

        private void CreateMenu()
        {
            MenuStrip menuStrip = new MenuStrip();
            
            ToolStripMenuItem fileMenu = new ToolStripMenuItem("File");
            ToolStripMenuItem exitItem = new ToolStripMenuItem("Exit");
            exitItem.Click += (s, e) => this.Close();
            fileMenu.DropDownItems.Add(exitItem);

            ToolStripMenuItem helpMenu = new ToolStripMenuItem("Help");
            ToolStripMenuItem aboutItem = new ToolStripMenuItem("About");
            aboutItem.Click += About_Click;
            helpMenu.DropDownItems.Add(aboutItem);

            menuStrip.Items.Add(fileMenu);
            menuStrip.Items.Add(helpMenu);
            
            this.MainMenuStrip = menuStrip;
            this.Controls.Add(menuStrip);
        }

        private void Button_Click(object sender, EventArgs e)
        {
            Button button = (Button)sender;
            string buttonText = button.Text;

            try
            {
                if (char.IsDigit(buttonText[0]))
                {
                    // Number button clicked
                    if (txtDisplay.Text == "0" || isOperationPerformed)
                    {
                        txtDisplay.Text = buttonText;
                        isOperationPerformed = false;
                    }
                    else
                    {
                        txtDisplay.Text += buttonText;
                    }
                }
                else if (buttonText == ".")
                {
                    if (!txtDisplay.Text.Contains("."))
                    {
                        txtDisplay.Text += ".";
                    }
                }
                else if (buttonText == "C")
                {
                    // Clear
                    txtDisplay.Text = "0";
                    txtHistory.Text = "";
                    firstNumber = 0;
                    currentOperation = "";
                }
                else if (buttonText == "CE")
                {
                    // Clear Entry
                    txtDisplay.Text = "0";
                }
                else if (buttonText == "=")
                {
                    // Calculate result
                    PerformCalculation();
                }
                else if (buttonText == "√")
                {
                    // Square root
                    double number = double.Parse(txtDisplay.Text);
                    double result = calculator.SquareRoot(number);
                    txtHistory.Text = $"√{number}";
                    txtDisplay.Text = result.ToString();
                    isOperationPerformed = true;
                }
                else
                {
                    // Operation button (+, -, *, /, x^y)
                    if (!string.IsNullOrEmpty(currentOperation) && !isOperationPerformed)
                    {
                        PerformCalculation();
                    }
                    
                    firstNumber = double.Parse(txtDisplay.Text);
                    currentOperation = buttonText;
                    txtHistory.Text = $"{firstNumber} {currentOperation}";
                    isOperationPerformed = true;
                }
            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.Message, "Error", MessageBoxButtons.OK, MessageBoxIcon.Error);
                txtDisplay.Text = "0";
                txtHistory.Text = "";
                currentOperation = "";
            }
        }

        private void PerformCalculation()
        {
            if (string.IsNullOrEmpty(currentOperation))
                return;

            double secondNumber = double.Parse(txtDisplay.Text);
            double result = 0;

            switch (currentOperation)
            {
                case "+":
                    result = calculator.Add(firstNumber, secondNumber);
                    break;
                case "-":
                    result = calculator.Subtract(firstNumber, secondNumber);
                    break;
                case "*":
                    result = calculator.Multiply(firstNumber, secondNumber);
                    break;
                case "/":
                    result = calculator.Divide(firstNumber, secondNumber);
                    break;
                case "x^y":
                    result = calculator.Power(firstNumber, secondNumber);
                    break;
            }

            txtHistory.Text = $"{firstNumber} {currentOperation} {secondNumber} =";
            txtDisplay.Text = result.ToString();
            currentOperation = "";
            isOperationPerformed = true;
        }

        private void About_Click(object sender, EventArgs e)
        {
            AboutForm aboutForm = new AboutForm();
            aboutForm.ShowDialog();
        }
    }
}

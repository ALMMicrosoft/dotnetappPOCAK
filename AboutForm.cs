using System;
using System.Drawing;
using System.Windows.Forms;

namespace Calculator
{
    public class AboutForm : Form
    {
        public AboutForm()
        {
            InitializeComponent();
        }

        private void InitializeComponent()
        {
            this.Text = "About Calculator";
            this.Size = new Size(400, 300);
            this.StartPosition = FormStartPosition.CenterParent;
            this.FormBorderStyle = FormBorderStyle.FixedDialog;
            this.MaximizeBox = false;
            this.MinimizeBox = false;
            this.BackColor = Color.White;

            // Icon/Logo Panel
            Panel logoPanel = new Panel
            {
                Location = new Point(0, 0),
                Size = new Size(400, 80),
                BackColor = Color.FromArgb(0, 122, 255)
            };
            this.Controls.Add(logoPanel);

            Label lblTitle = new Label
            {
                Text = "Calculator",
                Location = new Point(20, 20),
                Size = new Size(360, 40),
                Font = new Font("Segoe UI", 24, FontStyle.Bold),
                ForeColor = Color.White,
                BackColor = Color.Transparent
            };
            logoPanel.Controls.Add(lblTitle);

            // Version info
            Label lblVersion = new Label
            {
                Text = "Version 1.0.0",
                Location = new Point(20, 100),
                Size = new Size(360, 30),
                Font = new Font("Segoe UI", 12),
                ForeColor = Color.FromArgb(100, 100, 100)
            };
            this.Controls.Add(lblVersion);

            // Description
            Label lblDescription = new Label
            {
                Text = "A modern calculator application built with\n.NET Framework 4.8 and Windows Forms.\n\nFeatures:\n• Basic arithmetic operations\n• Power and square root functions\n• Clean and intuitive UI",
                Location = new Point(20, 140),
                Size = new Size(360, 100),
                Font = new Font("Segoe UI", 10),
                ForeColor = Color.Black
            };
            this.Controls.Add(lblDescription);

            // OK button
            Button btnOk = new Button
            {
                Text = "OK",
                Location = new Point(150, 220),
                Size = new Size(100, 35),
                Font = new Font("Segoe UI", 10, FontStyle.Bold),
                BackColor = Color.FromArgb(0, 122, 255),
                ForeColor = Color.White,
                FlatStyle = FlatStyle.Flat,
                Cursor = Cursors.Hand
            };
            btnOk.FlatAppearance.BorderSize = 0;
            btnOk.Click += (s, e) => this.Close();
            this.Controls.Add(btnOk);
        }
    }
}

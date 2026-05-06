// ✅ FIXED: No secrets in client-side code
// All authentication moved to server-side

let currentValue = '0';
let previousValue = null;
let operation = null;
let shouldResetDisplay = false;

const display = document.getElementById('display');
const history = document.getElementById('history');

function updateDisplay() {
    // ✅ FIXED: Use textContent to prevent XSS
    display.textContent = currentValue;
}

function updateHistory(text) {
    // ✅ FIXED: Use textContent to prevent XSS
    history.textContent = text;
}

function appendNumber(num) {
    if (shouldResetDisplay) {
        currentValue = num;
        shouldResetDisplay = false;
    } else {
        if (currentValue === '0') {
            currentValue = num;
        } else {
            currentValue += num;
        }
    }
    updateDisplay();
}

function appendDecimal() {
    if (shouldResetDisplay) {
        currentValue = '0.';
        shouldResetDisplay = false;
    } else if (!currentValue.includes('.')) {
        currentValue += '.';
    }
    updateDisplay();
}

function clearAll() {
    currentValue = '0';
    previousValue = null;
    operation = null;
    updateDisplay();
    updateHistory('');
}

function clearEntry() {
    currentValue = '0';
    updateDisplay();
}

function handleOperation(op) {
    if (op === 'sqrt') {
        calculateSquareRoot();
        return;
    }

    if (previousValue !== null && operation !== null && !shouldResetDisplay) {
        calculate();
    }

    previousValue = parseFloat(currentValue);
    operation = op;
    shouldResetDisplay = true;

    const symbols = {
        'add': '+',
        'subtract': '−',
        'multiply': '×',
        'divide': '÷',
        'power': '^'
    };

    updateHistory(`${previousValue} ${symbols[op]}`);
}

async function calculate() {
    if (previousValue === null || operation === null) {
        return;
    }

    const secondNumber = parseFloat(currentValue);
    
    try {
        // ✅ FIXED: No API key in headers, proper authentication should be server-side
        const response = await fetch('/api/calculate', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json'
                // Authentication should be handled via cookies/sessions server-side
            },
            body: JSON.stringify({
                firstNumber: previousValue,
                secondNumber: secondNumber,
                operation: operation
            })
        });

        // ✅ FIXED: No debug logging in production
        // Logging removed or should be behind feature flag

        if (!response.ok) {
            throw new Error('Network response was not ok');
        }

        const data = await response.json();

        if (data.error) {
            showError(data.error);
            return;
        }

        const symbols = {
            'add': '+',
            'subtract': '−',
            'multiply': '×',
            'divide': '÷',
            'power': '^'
        };

        updateHistory(`${previousValue} ${symbols[operation]} ${secondNumber} =`);
        currentValue = data.result.toString();
        updateDisplay();

        previousValue = null;
        operation = null;
        shouldResetDisplay = true;

    } catch (error) {
        showError('Connection error. Please try again.');
        console.error('Error:', error);
    }
}

async function calculateSquareRoot() {
    const number = parseFloat(currentValue);

    try {
        const response = await fetch('/api/calculate', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json'
            },
            body: JSON.stringify({
                firstNumber: number,
                secondNumber: 0,
                operation: 'sqrt'
            })
        });

        const data = await response.json();

        if (data.error) {
            showError(data.error);
            return;
        }

        updateHistory(`√${number} =`);
        currentValue = data.result.toString();
        updateDisplay();
        shouldResetDisplay = true;

    } catch (error) {
        showError('Connection error. Please try again.');
        console.error('Error:', error);
    }
}

function showError(message) {
    display.classList.add('error');
    display.textContent = message;
    
    setTimeout(() => {
        display.classList.remove('error');
        clearAll();
    }, 2000);
}

function showAbout() {
    document.getElementById('aboutModal').style.display = 'block';
}

function closeAbout() {
    document.getElementById('aboutModal').style.display = 'none';
}

// Close modal when clicking outside of it
window.onclick = function(event) {
    const modal = document.getElementById('aboutModal');
    if (event.target === modal) {
        modal.style.display = 'none';
    }
}

// Keyboard support
document.addEventListener('keydown', function(event) {
    if (event.key >= '0' && event.key <= '9') {
        appendNumber(event.key);
    } else if (event.key === '.') {
        appendDecimal();
    } else if (event.key === 'Enter' || event.key === '=') {
        calculate();
    } else if (event.key === 'Escape') {
        clearAll();
    } else if (event.key === '+') {
        handleOperation('add');
    } else if (event.key === '-') {
        handleOperation('subtract');
    } else if (event.key === '*') {
        handleOperation('multiply');
    } else if (event.key === '/') {
        event.preventDefault();
        handleOperation('divide');
    }
});

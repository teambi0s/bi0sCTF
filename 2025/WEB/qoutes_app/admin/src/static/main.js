const quoteIds = [
    "f47ac10b-58cc-4372-a567-0e02b2c3d479",
    "c9bf9e57-1685-4c89-bafb-ff5af830be8a",
    "e4eaaaf2-d142-11e1-b3e4-080027620cdd",
    "6ba7b810-9dad-11d1-80b4-00c04fd430c8",
    "1b9d6bcd-bbfd-4b2d-9b5d-ab8dfbbd4bed"
];

function buildApiUrl(baseUrl, quoteId) {
    return new URL(quoteId, `${window.location.origin}${baseUrl}`).toString();
}

async function fetchQuote(id) {
    try {
        const url = buildApiUrl("/api/quotes/", id);
        const response = await fetch(url, { method: "GET" });

        if (!response.ok) {
            throw new Error("Quote not found.");
        }

        const data = await response.json();
        return data.quote;
    } catch (error) {
        throw error;
    }
}

async function loadQuoteFromUrl() {
    const params = new URLSearchParams(window.location.search);
    const quoteId = params.get("quoteid");

    if (quoteId) {
        const quoteText = document.getElementById("quoteText");
        const errorText = document.getElementById("errorText");

        try {
            const quote = await fetchQuote(quoteId);
            quoteText.innerHTML = sanitizeHtml(quote);
            errorText.innerHTML = "";
        } catch (error) {
            quoteText.innerText = "Your quote will appear here.";
            errorText.innerText = error.message;
        }
    }
}

document.getElementById("getQuoteBtn").addEventListener("click", () => {
    const randomId = quoteIds[Math.floor(Math.random() * quoteIds.length)];
    window.location.search = `quoteid=${randomId}`;
});

// Load quote when the page loads
window.addEventListener("load", loadQuoteFromUrl);

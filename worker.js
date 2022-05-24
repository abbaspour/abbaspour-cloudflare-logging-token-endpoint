async function readRequestBody(request) {
    const {headers} = request
    const contentType = headers.get("content-type") || ""

    if (contentType.includes("application/json")) {
        return await request.json()
    } else if (contentType.includes("application/text")) {
        return request.text()
    } else if (contentType.includes("text/html")) {
        return request.text()
    } else if (contentType.includes("form")) {
        const formData = await request.formData()
        const body = {}
        for (const entry of formData.entries()) {
            body[entry[0]] = entry[1]
        }
        return body;
    } else {
        // Perhaps some other type of data was submitted in the form
        // like an image, or some other binary data.
        return 'a file';
    }
}

const encodeFormData = (data) => {
    return Object.keys(data)
        .map(key => encodeURIComponent(key) + '=' + encodeURIComponent(data[key]))
        .join('&');
}

async function gatherResponse(response) {
    const {headers} = response
    const contentType = headers.get("content-type") || ""
    if (contentType.includes("application/json")) {
        return JSON.stringify(await response.json())
    } else if (contentType.includes("application/text")) {
        return response.text()
    } else if (contentType.includes("text/html")) {
        return response.text()
    } else {
        return response.text()
    }
}


async function handleRequest(request) {

    const reqBody = await readRequestBody(request);

    console.log(`form data: ${JSON.stringify(reqBody)}`);

    const {code, client_id, client_secret, code_verifier, grant_type, redirect_uri} = reqBody;

    const body = {
        grant_type: grant_type,
        //client_id: `${client_id}`,
        //client_secret: client_secret,
        code: code,
        redirect_uri: redirect_uri
    };

    const init = {
        body: encodeFormData(body),
        method: "POST",
        headers: {
            'content-type': 'application/x-www-form-urlencoded',
            'Authorization': 'Basic bWNhZmVlX28ycHJvdGVjdF8yOm1jYWZlZV9vMnByb3RlY3Rfc2VjcmV0XzI='
        },
    };

    console.log(`sending token request to endpoint: ${ENDPOINT} with payload ${JSON.stringify(body)} using param of ${JSON.stringify(init)}`);
    const response = await fetch(`${ENDPOINT}`, init);
    const results = await gatherResponse(response);
    console.log(`result back from O2D: ${JSON.stringify(results)}`);
    const {id_token} = JSON.parse(results);

    return new Response(results, init);
}

addEventListener("fetch", event => {
    return event.respondWith(handleRequest(event.request))
})

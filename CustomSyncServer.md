# Writing Your Own Sync Server
When writing your own sync server for NoobDocs, your sync server must do the following:

- **Security Token** \
For security purposes, we expect that any implementation of the sync server expects an HTTP header named `Security-Token` that is received from the client. This is to prevent the unauthorized pushing and pulling of data from the sync server if it is exposed to the internet. In the example server, the server checks if the value of this header is the same as the `security_token` in the `config.json` file.

- **Support Get Requests on /pull** \
This route is what NoobDocs targets when making a pull request. When making a get request on this route, it needs to return a JSON object, and that JSON object needs to have a key titled "documents" and a value of the documents array.

- **Support Post Requests on /push** \
This route is where NoobDocs pushes its data to the sync server. When making a post request on this route, it needs to write the received JSON object to a file.
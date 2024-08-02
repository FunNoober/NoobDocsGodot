# Running in Docker
1. Clone this repository the machine that you intend on running the NoobDocs sync server on.

2. CD into the cloned repository and into `sync_server`
    > `cd NoobDocsGodot` \
    > `cd sync_server`

3. Open the `config.json` and change the `ip` field to `0.0.0.0`, while you are in here, change your security token and port to what you wish.

4. Open the file titled `dockerfile`, and where it says `EXPOSE 8567`, change that to `EXPOSE {{YOUR DESIRED PORT}}`
    > Example: `EXPOSE 8485`
5. Run the command `docker build -t noobdocs-sync-server .` Add `sudo` before the command if getting an authorization error.

6. Run the command `docker run -d --name noobdocs_sync_server -p {YOUR TARGET PORT}:{YOUR TARGET PORT} noobdocs-sync-server`
    > Example `docker run -d --name noobdocs_sync_server -p 8485:8485 noobdocs-sync-server`
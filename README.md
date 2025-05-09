<h1>Webminal Container</h1>

Web based terminals (webminals) have continued to be useful for accessing a remove server simply via a webpage. Many of the webminals require multiple development steps and / or building an application to comlplete this action. This <text style="color : #0b8000">Containerized Website Terminal</text> is intended to use a simplier approach.

<h2 style="color : #0b8000">Containerized Website Terminal</h2>

This container (e.g., docker) for webminal uses [tini](https://github.com/krallin/tini), [ttyd](https://github.com/tsl0922/ttyd), and [tmux](https://github.com/tmux/tmux). This is provided as an example of how to implement a containerized terminal, that allows web access. This is provided free of charge, and does not come with any implicit warranty. This software is provided as is.

<h3>Demo</h3>


<h3>Setup</h3>

1. <code>git clone https://github.com/0p3nt3ch53C/webminal-container.git wmc </code>
2. <code>cd wmc</code>
3. <code>docker build -t webminal-container .</code>
4. <code>docker run --rm -d -p 8080:8080 --name webminal-container webminal-container:latest</code>
5. <code>docker logs webminal-container -f</code>


<h3>Use Cases</h3>

1. Capure the Flag (CTF) competitions.
2. Testing specific unix / linux software.

<h3>Features</h3>

1. Allows multiple users to have web based access.
2. Allows users access to the same container file system <text style="color : #f03636">IMPORTANT:</text> this does not allow a filesystem / container per user. Each new user shares the same container.
3. Unlocks automation capabilities based on containerization

<h3>Concerns</h3>

1. Does not allow for authentication (no/limited security).
2. <text style="color : #ebad28">[BUG]</text> Requires a specific version of alpine container as a baseline.

<h3>Options</h3>

* Session Duration (**default 2 minutes**): Updated via *tmux-session-handler.sh* script (line 3).
* Session Timeout (**default 8 minutes**): Updated via *tmux-session-handler.sh* script (line 4).
* Maxium Sessions (**default 3 session**): Updated via dockerfile (last line).


A WebSocket + touch device experiment. The socket is used to send touch input
from a tablet or phone to other devices (e.g. computers) on the web page.
The lag is actually close to negligible when used on a regular local network.

I'm sure there are useful/fun applications for this (Wii U-like local multiplayer
games, presentation tools, etc).

Once the WebRTC implementations in browsers start to allow arbitrary data to be sent
through the peer connection (DataChannel API), a server won't be needed to handle
the in-between communication. This could potentially allow this technique
to be used on a larger scale and not just on local networks.

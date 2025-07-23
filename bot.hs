const { default: makeWASocket, useMultiFileAuthState, makeCacheableSignalKeyStore } = require("@whiskeysockets/baileys");
const pino = require("pino");
const path = require("path");

async function startBot(sessionId) {
  const sessionDir = path.join(__dirname, "temp", sessionId);
  const { state, saveCreds } = await useMultiFileAuthState(sessionDir);

  const sock = makeWASocket({
    auth: {
      creds: state.creds,
      keys: makeCacheableSignalKeyStore(state.keys, pino({ level: "silent" })),
    },
    logger: pino({ level: "silent" }),
  });

  sock.ev.on("creds.update", saveCreds);

  sock.ev.on("messages.upsert", async ({ messages }) => {
    const msg = messages[0];
    if (!msg.message || msg.key.fromMe) return;

    const from = msg.key.remoteJid;
    const body = msg.message.conversation || msg.message.extendedTextMessage?.text || "";

    if (body === ".alive") {
      await sock.sendMessage(from, {
        text: "👑 *Rahl Quantum Bot is Alive!*\n\n🧠 Powered by Baileys\n⚔️ Ready to Serve.",
      });
    }

    if (body === ".ping") {
      await sock.sendMessage(from, {
        text: "🏓 *Royal Pong!* — Rahl Quantum here!",
      });
    }

    if (body === ".menu") {
      await sock.sendMessage(from, {
        text: `📜 *Royal Commands*:
        
1. .alive — Check bot status
2. .ping — Test response
3. .menu — Show commands
...more coming soon 👑`,
      });
    }
  });
}

module.exports = { startBot };

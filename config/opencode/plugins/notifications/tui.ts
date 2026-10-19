import { writeFileSync } from "node:fs"
import { Plugin } from "@opencode/plugin/tui"

const bell = () => {
  try {
    writeFileSync("/dev/tty", "\x07")
  } catch {
    process.stdout.write("\x07")
  }
}

export default Plugin.define({
  id: "notifications",
  setup(context) {
    let last = 0

    const notify = (sessionID: string) => {
      const focused = (context.renderer as any)._terminalFocusState !== false
      const route = context.ui.router.current()
      const active = route.type === "session" ? route.sessionID : undefined
      const tabs = context.ui.tabs.list().map((tab) => tab.sessionID)
      const session = context.data.session.get(sessionID)
      const location = session?.location.directory
      const local = !location || !context.location?.directory || location === context.location.directory
      const relevant = tabs.length > 0 ? tabs.includes(sessionID) : sessionID === active

      if (focused || !local || !relevant) return

      const now = Date.now()
      if (now - last < 500) return
      last = now
      bell()
    }

    const stopPermission = context.data.on("permission.asked", (event) => notify(event.data.sessionID))
    const stopForm = context.data.on("form.created", (event) => notify(event.data.form.sessionID))
    const stopSuccess = context.data.on("session.execution.succeeded", (event) => {
      const session = context.data.session.get(event.data.sessionID)
      if (!session?.parentID) notify(event.data.sessionID)
    })
    const stopFailure = context.data.on("session.execution.failed", (event) => {
      const session = context.data.session.get(event.data.sessionID)
      if (!session?.parentID) notify(event.data.sessionID)
    })

    return () => {
      stopPermission()
      stopForm()
      stopSuccess()
      stopFailure()
    }
  },
})

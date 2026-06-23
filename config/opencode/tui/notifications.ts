import type { TuiPlugin, TuiPluginApi } from "@opencode-ai/plugin/tui";

const beep = () => process.stdout.write("\x07");
// NOTE: customize this function to do more than just beep
const alert = beep;

const id = "notifications";

interface SessionInfo {
  isChild: boolean;
  title: string | null;
}

const getSessionInfo_ = async (
  client: TuiPluginApi["client"],
  sessionID: string,
): Promise<SessionInfo> => {
  try {
    const response = await client.session.get({ sessionID });
    const title =
      typeof response.data?.title === "string" ? response.data.title : null;
    return {
      isChild: !!response.data?.parentID,
      title,
    };
  } catch {
    return { isChild: false, title: null };
  }
};

const tui: TuiPlugin = async (api) => {
  const childrenCache = new Map<string, boolean>();
  const isChild = async (sessionID: string): Promise<boolean> => {
    if (childrenCache.has(sessionID)) return childrenCache.get(sessionID)!;
    const info = await getSessionInfo_(api.client, sessionID);
    childrenCache.set(sessionID, info.isChild);
    return info.isChild;
  };

  const hasFocus =
    "_terminalFocusState" in (api.renderer as any)
      ? (): boolean => (api.renderer as any)._terminalFocusState ?? true
      : ((): (() => boolean) => {
          let focused: boolean = true;
          api.renderer.on("focus", () => {
            focused = true;
          });
          api.renderer.on("blur", () => {
            focused = false;
          });
          return (): boolean => focused;
        })();

  const notify = (): void => {
    if (!hasFocus()) alert();
  };

  api.event.on("permission.asked", notify);
  api.event.on("question.asked", notify);
  api.event.on("session.idle", (ev): void => {
    (async (): Promise<void> => {
      if (!hasFocus() && !(await isChild(ev.properties.sessionID))) alert();
    })();
  });
  api.event.on("session.deleted", (ev): void => {
    childrenCache.delete(ev.properties.sessionID);
  });
};

export default { id, tui };

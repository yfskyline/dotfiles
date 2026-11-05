#!/usr/bin/env python3
# @raycast.schemaVersion 1
# @raycast.title Add Notion Todo
# @raycast.mode compact
# @raycast.icon ✅
# @raycast.argument1 { "type": "text", "placeholder": "TODOを入力" }

import sys
import json
import getpass
import subprocess
import urllib.request
import urllib.error

# 追加先のNotionのBLOCK_ID
BLOCK_ID = "40f0718aaca9808b920df2da622ebcbd"

# "end" = 末尾、"start" = 先頭
POSITION = "start"

def main():
    title = sys.argv[1].strip()

    if not title:
        sys.exit("TODOが空です")

    if len(title) > 2000:
        sys.exit("TODOは2000文字以内にしてください")

    # macOS Keychainからトークンを取得
    token = subprocess.check_output(
        [
            "/usr/bin/security",
            "find-generic-password",
            "-a", getpass.getuser(),
            "-s", "raycast-notion",
            "-w"
        ],
        text=True
    ).strip()

    payload = {
        "children": [
            {
                "object": "block",
                "type": "to_do",
                "to_do": {
                    "rich_text": [
                        {
                            "type": "text",
                            "text": {"content": title}
                        }
                    ],
                    "checked": False
                }
            }
        ],
        "position": {"type": POSITION}
    }

    request = urllib.request.Request(
        f"https://api.notion.com/v1/blocks/{BLOCK_ID}/children",
        data=json.dumps(payload, ensure_ascii=False).encode("utf-8"),
        headers={
            "Authorization": f"Bearer {token}",
            "Notion-Version": "2026-03-11",
            "Content-Type": "application/json"
        },
        method="PATCH"
    )

    try:
        with urllib.request.urlopen(request, timeout=15):
            print(f"追加しました: {title}")
    except urllib.error.HTTPError as e:
        detail = e.read().decode("utf-8")
        sys.exit(f"Notion API Error {e.code}: {detail}")
    except urllib.error.URLError as e:
        sys.exit(f"通信エラー: {e.reason}")


if __name__ == "__main__":
    main()

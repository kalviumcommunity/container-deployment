   #!/bin/sh
   set -eu
   BASE_URL=${BASE_URL:-http://127.0.0.1:18082}
   python3 - "$BASE_URL" <<'PY' || true
import json,sys,urllib.request
base=sys.argv[1]
for route in ['/health','/notes']:
 with urllib.request.urlopen(base+route,timeout=4) as r:
  assert r.status==200
  data=json.load(r)
  assert data.get('status')=='ok' if route=='/health' else isinstance(data.get('notes'),list)
PY
   echo 'Release checks passed'

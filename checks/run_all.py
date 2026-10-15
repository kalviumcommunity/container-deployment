import subprocess,sys
checks=['container', 'service', 'config', 'runtime']
failures=[]
for check in checks:
 result=subprocess.run([sys.executable,'checks/check.py',check])
 if result.returncode:failures.append(check)
print('Failed checks:',failures)
sys.exit(bool(failures))

#!/usr/bin/env python
#
import os, sys, stat
from xml_funcs.base import header_begin, header_entities, header_end, source, \
  wflow_begin, wflow_log, wflow_cycledefs, wflow_end
from xml_funcs.tasks1 import ic, lbc, da, fcst
from xml_funcs.tasks2 import mpassit, upp
from xml_funcs.tasksX import clean, graphics #archive

### setup_xml
def setup_xml(expdir):
  # source the config cascade
  machine=os.getenv('MACHINE').lower()
  source(f'{expdir}/exp.setup')
  #
  source(f'{expdir}/config/config.pre',optional=True)
  source(f"{expdir}/config/config.{machine}")
  source(f"{expdir}/config/config.base")
  #
  source(f'{expdir}/config/resources/config.pre',optional=True)
  source(f"{expdir}/config/resources/config.{machine}")
  source(f"{expdir}/config/resources/config.base")
  if os.getenv("REALTIME").upper() == "TRUE":
    source(f"{expdir}/config/resources/config.realtime")
  #
  dcCycledef={}
  dcCycledef['ic']=os.getenv('CYCLEDEF_IC')
  dcCycledef['lbc']=os.getenv('CYCLEDEF_LBC')
  #dcCycledef['spinup']=os.getenv('CYCLEDEF_SPINUP')
  dcCycledef['prod']=os.getenv('CYCLEDEF_PROD') #gge.debug
  
  COMROOT=os.getenv('COMROOT','COMROOT_not_defined')
  TAG=os.getenv('TAG','TAG_not_defined')
  NET=os.getenv('NET','NET_not_defined')
  VERSION=os.getenv('VERSION','VERSION_not_defined')

  fPath=f"{expdir}/rrfs.xml"
  with open(fPath, 'w') as xmlFile:
    header_begin(xmlFile)
    header_entities(xmlFile,expdir)
    header_end(xmlFile)
    wflow_begin(xmlFile)
    log_fpath=f'{COMROOT}/{NET}/{VERSION}/logs/rrfs.@Y@m@d/@H/rrfs_{TAG}.log'
    wflow_log(xmlFile,log_fpath)
    wflow_cycledefs(xmlFile,dcCycledef)
    
    # assemble tasks for an experiment or setup/generate an xml file
    ic(xmlFile,expdir)
    lbc(xmlFile,expdir)
    da(xmlFile,expdir)
    fcst(xmlFile,expdir)
    if machine == "jet": #currently only support mpassit on jet using pre-compiled mpassit
      mpassit(xmlFile,expdir)
      upp(xmlFile,expdir)
      graphics(xmlFile,expdir)
    if os.getenv("REALTIME").upper() == "TRUE": # write out the clean task for realtime runs and retros don't need it
      clean(xmlFile,expdir)
  
    wflow_end(xmlFile)

  fPath=f"{expdir}/run_rocoto.sh"
  with open(fPath,'w') as rocotoFile:
    text= \
f'''#!/usr/bin/env bash
source /etc/profile
module load rocoto
cd {expdir}
rocotorun -w rrfs.xml -d rrfs.db
'''
    rocotoFile.write(text)

  # set run_rocoto.sh to be executable
  st = os.stat(fPath)
  os.chmod(fPath, st.st_mode | stat.S_IEXEC)

  print(f'rrfs.xml and run_rocoto.sh has been created at:\n  {expdir}')
### end of setup_xml

### run setup_xml.py from the command line
if __name__ == "__main__":
  # get the expdir from the command line
  if len(sys.argv) != 2:
    print("Usage: setup_xml.py expdir")
    sys.exit(1)
  
  # Retrieve arguments - the path to the exp_setting file
  expdir = sys.argv[1]
  if not os.path.isdir(expdir):
    print(f'"{expdir}" is not a directory')
    sys.exit(1)

  setup_xml(expdir)

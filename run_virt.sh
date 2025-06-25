#!/bin/sh

dinitctl start virtchd
dinitctl start virtinterfaced
dinitctl start virtlockd
dinitctl start virtlogd
dinitctl start virtnetworkd
dinitctl start virtnodedevd
dinitctl start virtnwfilterd
dinitctl start virtproxyd
dinitctl start virtqemud
dinitctl start virtsecretd
dinitctl start virtstoraged


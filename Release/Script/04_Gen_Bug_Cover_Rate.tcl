source ../Script/00_Compile_Make_Bug.tcl
./simv
urg -dir simv.vdb
firefox $cwd/urgReport/dashboard.html &

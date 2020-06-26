package require Tk
set file_name ""
#Proc to open file
set pwd1 [pwd]
proc compile {} {
	global file_name
	if {$file_name == ""} {
		tk_messageBox -icon error -title "No file selected" -type ok -message "Open a file to compile"
	} else {
                regsub {\\program_files\\(.*)$} $::argv0 {\program_files\print_bkp.tk} source_file_name
		source $source_file_name
		main $file_name
		tk_messageBox -icon info -title "Compilation Successful" -type ok -message "Successful compilation"
	}
}

proc run {} {
	global file_name
        regsub {/my_files/(.*)$} $file_name {/program_files/output.a} source_file_name
	if {[file isfile $source_file_name] == 0} {
		tk_messageBox -icon error -title "Compilation not done" -type ok -message "Please compile first"
	} else {
                regsub {/my_files/(.*)$} $file_name {/program_files/output.a} source_file_name
                regsub {/my_files/(.*)$} $file_name {/program_files/output1.a} op_file_name
		exec wish -encoding utf-8 $source_file_name 
	}
}
proc save_file {} {
	global file_name
	if {[winfo exists .t] == 0 } {
		tk_messageBox -icon error -title "Text window not found" -type ok -message "Please open a new or existing file"
		return
 	} elseif {$file_name == ""} {
		tk_messageBox -icon error -title "Text window not found" -type ok -message "Please open a new or existing file"
		return
	}
	if { $file_name != "" } {
		set file1 [open $file_name w]
		fconfigure $file1 -encoding utf-8
		set i 1;
		while {$i < [.t index end]} {
			set j 0;
			set k 1
			set i1 ${i}.${j}
			set i2 ${i}.${k}
			while { $i2 == [.t index $i2] } {
				set b [.t get $i1 $i2];
				puts -nonewline $file1 $b
				set j [expr $j+1];
				set k [expr $k+1];
				set i1 ${i}.${j}
				set i2 ${i}.${k}
			}
			set i [expr $i+1];
			puts $file1 "\n"
		}
		close $file1
		set file1 [open $file_name r]
		set file2 [open ${file_name}_temp w]
		fconfigure $file1 -encoding utf-8
		fconfigure $file2 -encoding utf-8
		while {[gets $file1 line]>=0} {
			if {[regexp {^\s*$} $line] == 1} {
			} else {
				regsub -all {^M} $line {} line1
				puts $file2 $line1
			}
		}		
		close $file1
		close $file2
		set file1 [open $file_name w]
		set file2 [open ${file_name}_temp r]
		fconfigure $file1 -encoding utf-8
		fconfigure $file2 -encoding utf-8
		while {[gets $file2 line]>=0} {
			puts $file1 $line
		}		
		close $file1
		close $file2
		file delete ${file_name}_temp
	}
}
#Proc to save as file
proc save_as_file {} {
	global file_name
	if {[winfo exists .t] == 0 } {
		tk_messageBox -icon error -title "Text window not found" -type ok -message "Please open a new or existing file"
		return
 	} 
	set types {
		{{A Language Files} {.a}}
		{{All Files} *}
	}
        regsub {\\program_files\\(.*)$} $::argv0 {\my_files} initial_dir1
	set types {
		{{A Language Files} {.a}}
		{{All Files} *}
	}
	set file_name [tk_getSaveFile -defaultextension a -filetypes $types -initialdir $initial_dir1]
	if { $file_name != "" } {
		set file1 [open $file_name w]
		fconfigure $file1 -encoding utf-8
		set i 1;
		while {$i < [.t index end]} {
			set j 0;
			set k 1
			set i1 ${i}.${j}
			set i2 ${i}.${k}
			while { $i2 == [.t index $i2] } {
				set b [.t get $i1 $i2];
				puts -nonewline $file1 $b
				set j [expr $j+1];
				set k [expr $k+1];
				set i1 ${i}.${j}
				set i2 ${i}.${k}
			}
			set i [expr $i+1];
			puts $file1 "\n"
		}
		close $file1
		set file1 [open $file_name r]
		set file2 [open ${file_name}_temp w]
		fconfigure $file1 -encoding utf-8
		fconfigure $file2 -encoding utf-8
		while {[gets $file1 line]>=0} {
			if {[regexp {^\s*$} $line] == 1} {
			} else {
				regsub -all {^M} $line {} line1
				puts $file2 $line1
			}
		}		
		close $file1
		close $file2
		set file1 [open $file_name w]
		set file2 [open ${file_name}_temp r]
		fconfigure $file1 -encoding utf-8
		fconfigure $file2 -encoding utf-8
		while {[gets $file2 line]>=0} {
			puts $file1 $line
		}		
		close $file1
		close $file2
		file delete ${file_name}_temp
	}
}


#Proc to open new file
proc new_file {} {
   
   if {[winfo exists .t]} {
      set answer [tk_messageBox -icon question -title "Save existing file???" -type yesnocancel -message "Do you want to save existing file?"]
      switch -- $answer {
         yes {
                save_file
               destroy .t
         }
         no {destroy .t}
         cancel {return}
      }
   }
   destroy .f
   global res_win
   set res_win [text .t -width 1000 -height 290]
   pack .t -expand 0 -side top
   focus .t 
}
proc open_file {} {
	global file_name
	set types {
		{{A Language Files} {.a}}
		{{All Files} *}
	}
        regsub {\\program_files\\(.*)$} $::argv0 {\my_files} initial_dir1
	set file_name [tk_getOpenFile -filetypes $types -initialdir $initial_dir1]
	if {$file_name != ""} {
		set file1 [open $file_name r]
		fconfigure $file1 -encoding utf-8
		set line_no 0
		new_file 	
		while {[gets $file1 line]>=0} {
			.t insert end ${line}\n
		}
		close $file1
	}
}



wm title . "3-T" 
#wm resizable . 0 0
frame .f -width 1000 -height 490
pack .f
#set file_name "Click on open button to open file here"
menu .menu
. configure -menu .menu
bind . <KeyPress-Control_L><n> {new_file}
bind . <KeyPress-Control_R><n> {new_file}
bind . <KeyPress-Control_L><o> {open_file}
bind . <KeyPress-Control_R><o> {open_file}
bind . <KeyPress-Control_L><s> {save_file}
bind . <KeyPress-Control_R><s> {save_file}
bind . <F9> {compile}
bind . <F10> {run}

menu .menu.file1
.menu add cascade -menu .menu.file1 -label File
.menu.file1 add command -label "New    ctrl+n" -command {new_file} 
.menu.file1 add command -label "Open   ctrl+o" -command {open_file} 
.menu.file1 add command -label "Save   ctrl+s" -command {save_file} 
.menu.file1 add command -label "Save as" -command {save_as_file} 

menu .menu.execute
.menu add cascade -menu .menu.execute -label Execute
.menu.execute add command -label "Compile   F9" -command {compile}
.menu.execute add command -label "Run       F10" -command {run}

menu .menu.help
.menu add cascade -menu .t.menu.help -label Help
set result [frame .result -width 1000 -height 6 ]
#.result configure -state disabled
pack .result -side bottom 
label .result.res_label -text "Result" -font {{Times New Roman} 10 bold} -foreground blue
pack .result.res_label -side top
text .result.op -width 1000 -height 9
.result.op configure -state disabled 
pack .result.op -expand 1 -fill both
#.f.menu.execute add cascade -menu [list .f.menu.execute.compile .f.menu.execute.run] -label Execute
#.f.menu.execute.compile add command -label Compile -command {compile} 
#.f.menu.execute.run add command -label Run -command {run}

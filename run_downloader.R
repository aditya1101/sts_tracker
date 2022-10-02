#This script is for downloading/re-downloading the STS run files from the Steam folder
#it will be sourced at the beginning of run_tracker.R

rundata_dir = "/Users/adityarao/Library/Application Support/Steam/SteamApps/common/SlayTheSpire/SlayTheSpire.app/Contents/Resources/runs"
storage_dir = "/Users/adityarao/personal_projects/sts_tracker/"

#make folder to store run history
storage_dir = file.path(storage_dir,"all_run_history")
if(!dir.exists(storage_dir)){
  dir.create(storage_dir,recursive=T)
}

#make folders to store individual character run histories
if(!dir.exists(file.path(storage_dir,"IRONCLAD"))){
  dir.create(file.path(storage_dir,"IRONCLAD"),recursive=T)
}
if(!dir.exists(file.path(storage_dir,"THE_SILENT"))){
  dir.create(file.path(storage_dir,"THE_SILENT"),recursive=T)
}
if(!dir.exists(file.path(storage_dir,"DEFECT"))){
  dir.create(file.path(storage_dir,"DEFECT"),recursive=T)
}
if(!dir.exists(file.path(storage_dir,"WATCHER"))){
  dir.create(file.path(storage_dir,"WATCHER"),recursive=T)
}

#transfer over any new run files

char_vec = c("IRONCLAD","THE_SILENT","DEFECT","WATCHER")
df = setNames(data.frame(matrix(ncol = 4, nrow = 1)), char_vec)

for(character in char_vec){
  all_runs_full = list.files(file.path(rundata_dir,character),full.names = T)
  all_runs = list.files(file.path(rundata_dir,character))
  stored_runs = list.files(file.path(storage_dir,character))
  runs_to_copy = setdiff(all_runs,stored_runs)
  runs_to_copy_full = all_runs_full[which(all_runs %in% runs_to_copy)]
  if(length(runs_to_copy) > 0){
    out = file.copy(runs_to_copy_full, file.path(storage_dir,character))
    if(any(!out)){
      stop(sprintf("File transfer failed for %s",character))
    }
  }
  if(length(list.files(file.path(rundata_dir,character))) != length(list.files(file.path(storage_dir,character)))){ #sanity check to see if number of files is the same
    if(list.files(file.path(rundata_dir,character)) != list.files(file.path(storage_dir,character))){#sanity check to see if all files are the same
      stop(sprintf("Mismatching files present in the source vs. storage location for %s run files",character))
    }else{
      stop(sprintf("Different numbers of files present in the source vs. storage location for %s run files",character))
    }
  }
  df[character] = length(runs_to_copy)
}

#output what files have been added
cat(sprintf("Added %s new Ironclad run files\n",df["IRONCLAD"]))
cat(sprintf("Added %s new Silent run files\n",df["THE_SILENT"]))
cat(sprintf("Added %s new Defect run files\n",df["DEFECT"]))
cat(sprintf("Added %s new Watcher run files\n",df["WATCHER"]))







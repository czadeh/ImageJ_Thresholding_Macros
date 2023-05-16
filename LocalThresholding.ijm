dir = getDirectory("Choose a Directory to PROCESS"); 
list = getFileList(dir);                                             
dir2 = getDirectory("Choose a Directory for SAVING");  

//setBatchMode(true); 
for (f=0; f<list.length; f++) { 
	path = dir+list[f];
	if (!endsWith(path,"/") && endsWith(path,".png")) {
		open(path);
		setAutoThreshold("Default");
		//run("Threshold...");
		t=getTitle();                                        
		s=lastIndexOf(t, '.');
		t=substring(t, 0,s); 
		t=replace(t," ","_"); 
		t2= t +'_processed';
        		run("Measure");  		
       		run("Convert to Mask");
        		saveAs("Tiff", dir2 + t2 + ".tif");
        		close();
	 } 
}                   

saveAs("Results",dir2+"Results.csv");

dir = getDirectory("Choose a Directory to PROCESS"); 
list = getFileList(dir);                                             
dir2 = getDirectory("Choose a Directory for SAVING");  

minThreshold = getNumber("Enter minimum threshold value:", 0);
maxThreshold = getNumber("Enter maximum threshold value:", 255);

//setBatchMode(true); 
for (f=0; f<list.length; f++) { 
	path = dir+list[f];
	if (!endsWith(path,"/") && endsWith(path,".png")) {
		open(path);
		setThreshold(minThreshold, maxThreshold);
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

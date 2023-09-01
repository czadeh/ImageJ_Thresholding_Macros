dir = getDirectory("Choose a Directory to PROCESS"); 

// Create "local" and "global" subfolders
File.makeDirectory(dir + "local");
File.makeDirectory(dir + "global");

localDir = dir + "local" + File.separator;
globalDir = dir + "global" + File.separator;

list = getFileList(dir);

function findMode(arr) {
    arr = Array.sort(arr);
    var maxValue = 0, maxCount = 0, i, j;
    for (i = 0; i < arr.length; i++) {
        var count = 0;
        for (j = i; j < arr.length; j++) {
            if (arr[j] == arr[i])
                count++;
            else
                break;
        }
        if (count > maxCount) {
            maxCount = count;
            maxValue = arr[i];
        }
    }
    return maxValue;
}

// Local Thresholding Algorithm
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
        saveAs("Tiff", localDir + t2 + ".tif");
        close();
     } 
}                   

saveAs("Local_Results", localDir + "Local_Results.csv");

// Clear results
run("Clear Results");

// Determine statistical mode of MinThr and MaxThr from local results
minThrArray = newArray();
maxThrArray = newArray();

Table.open(localDir + "Local_Results.csv");
minThrCol = Table.getColumn("MinThr");
maxThrCol = Table.getColumn("MaxThr");
for (i=0; i<minThrCol.length; i++) {
    minThrArray = Array.concat(minThrArray, minThrCol[i]);
    maxThrArray = Array.concat(maxThrArray, maxThrCol[i]);
}
run("Close");

minThreshold = findMode(minThrArray);
maxThreshold = findMode(maxThrArray);

// Global Thresholding Algorithm
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
        saveAs("Tiff", globalDir + t2 + ".tif");
        close();
     } 
}                   

saveAs("Global_Results", globalDir + "Global_Results.csv");

This tool will calculate the price of an asset if it were at another assets market cap.
It will specifically compare all assets you specify against the first 3 rows of data.

1. Download and place the following files into the same folder on your machine:
	MarketCapCompare.ps1
	input.csv
2. Fill your data into the input.csv similar to the ExampleInput.csv
3. Make sure you can run powershell scripts on your computer by running the following command in a powershell window as administrator
	Get-ExecutionPolicy -List
4. If the Localmachine is undefined or restricted, run the following
	set-ExecutionPolicy Unrestricted
	then enter 'y' to the prompt
	*** you can change this back later if you desire
5. Finally open the folder containing the MarketCapCompare.ps1 script, right click and run with powershell
6. Two new files will be generated displaying the results

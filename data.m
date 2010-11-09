%ME495 HAVC Lab 2010@umich, Bert Jiang
clear
Means=0;  %Matrix to hold mean
Std=0;    %Matrix to hold Std
Std_Means=0;%Matrix to hold std of mean
User=0;  	%Matrix to hold user input

response = input('Paste your file name(w/o numbers) here. \nFor example, Heat Excahnger_test1.txt would be Heat Excahnger_test\n','s')
num = input('how many tests in total?','s')
%Read in all the environment variable (user input) --done
	for i=1:str2num(num)
	filename = [response num2str(i) '.txt'];
	fid=fopen(filename); %open file
	foo=textscan(fid,'%s','HeaderLines',4,'delimiter','\n');
	foo=foo{1,1};
	%Now deal with formatted data
		for j=1:7
			numbers=regexp(foo{j,1},'[-+]?([0-9]*\.[0-9]+|[0-9]+)','match');
			numbers=wrev(numbers); %flip vector
			numbers=numbers(1); %get the first #
			numbers=wrev(numbers); %and flip back
			User(i,j)=str2num(cell2mat(numbers(1,1)));		
		end
	fclose(fid);
	end
	
%Generate mean, std, and std of mean matrix --done
	for i=1:str2num(num)
		filename = [response num2str(i) '.txt'];
		fid=fopen(filename); %open file
		%skip all the environment variables
		foo=textscan(fid,'%s','HeaderLines',13,'delimiter','\n');
		foo=foo{1,1};
	%Now deal with formatted data
		for j=1:size(foo,1)
			%now find the numbers using regexp
			numbers=regexp(foo{j,1},'[-+]?([0-9]*\.[0-9]+|[0-9]+)','match');
			numbers=wrev(numbers); %flip vector
			numbers=numbers(1:3); %get the first three #'s
			numbers=wrev(numbers); %and flip back		
			Means(i,j)=str2num(cell2mat(numbers(1,1)));
			Std(i,j)=str2num(cell2mat(numbers(1,2)));
			Std_Means(i,j)=str2num(cell2mat(numbers(1,3)));
		end
		fclose(fid); %close file
	end



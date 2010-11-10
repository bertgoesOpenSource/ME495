%ME495 HAVC Lab 2010@umich, Bert Jiang
function []=data()
clear
Means=0;  %Matrix to hold mean
Std=0;    %Matrix to hold Std
Std_Means=0;%Matrix to hold std of mean
User=0;  	%Matrix to hold user input

response = input('Paste your file name(w/o numbers) here. \nFor example, Heat Excahnger_test1.txt would be Heat Excahnger_test\n','s');
num = input('how many tests in total?','s');
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

Std_error=0;
	for i=1:size(Std,2)
		Std_error(1,i) = 2*sqrt(Std(1,i)^2+Std(2,i)^2+Std(3,i)^2)/3;
	end
	
Mean_want = mean(Means,1);

for i=1:size(Std,2)
	Matrix_Out(i,:) = [Mean_want(1,i)-Std_error(1,i) Mean_want(1,i) Mean_want(1,i)+Std_error(1,i)];
end




fid=fopen([response '_done.txt'],'w');
fprintf(fid,'Pressure in MPa, Temperature Celsius\n');
fprintf(fid,'*********************Evaporator #1 Out*********************\n');
writeFile(1,18,Matrix_Out,response,fid);
%fclose(fid);

%fid=fopen([response '_done.txt'],'a');
fprintf(fid,'*********************Evaporator #2 Out*********************\n');
writeFile(2,21,Matrix_Out,response,fid);
%fclose(fid);

%fid=fopen([response '_done.txt'],'a');
fprintf(fid,'*********************Compressor In*********************\n');
writeFile(8,19,Matrix_Out,response,fid);
%fclose(fid);

%fid=fopen([response '_done.txt'],'a');
fprintf(fid,'*********************Compressor Out*********************\n');
writeFile(9,20,Matrix_Out,response,fid);
%fclose(fid);

%fid=fopen([response '_done.txt'],'a');
fprintf(fid,'*********************Condenser In*********************\n');
writeFile(3,17,Matrix_Out,response,fid);
%fclose(fid);
%fid=fopen([response '_done.txt'],'a');
fprintf(fid,'*********************Condenser Out*********************\n');
writeFile(4,17,Matrix_Out,response,fid);

fprintf(fid,'*********************Evaporator #1 in*********************\n');
fprintf(fid,'%f %f %f\n',Matrix_Out(15,:));
fprintf(fid,'*********************Evaporator #2 in*********************\n');
fprintf(fid,'%f %f %f\n',Matrix_Out(16,:));
fprintf(fid,'*********************Evaporator #1 flow*********************\n');
fprintf(fid,'Flow Rate (ml/min): %f %f %f\n',Matrix_Out(22,:));

fprintf(fid,'*********************Evaporator #2 flow*********************\n');
fprintf(fid,'Flow Rate (ml/min): %f %f %f\n',Matrix_Out(23,:));


fprintf(fid,'*********************Power*********************\n');
fprintf(fid,'Power: %f %f %f\n',Matrix_Out(24,:));


fclose(fid);




function []=writeFile(a,b,Matrix_Out,response,fid)
Atmosphere=98.84;
%fid = fopen([response '_done.txt'],'w');

for i=1:3
	for j=1:3
		fprintf(fid,'T=%f,P=%f  ',Matrix_Out(a,i) , 1e-3*(Matrix_Out(b,j)+Atmosphere));
		if(j==3)
		fprintf(fid,'\n');
		end
	end
end
%fclose(fid);
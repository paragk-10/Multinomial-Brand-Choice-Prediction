data crackers_hw5;
set 'crackers_hw5.sas7bdat';
run;

proc print data=crackers_hw5;
run;

proc surveyselect data=crackers_hw5 out=crackers_hw5_sampled outall samprate=0.80 seed=100;
run;

/* 2nd Question's Answer: 
Refer Word Document
*/

data crackers_hw5_1(keep=subject choice price feature display brand);
 array chosen[4] Private Sunshine Keebler Nabisco;
 array chosen_price[4] PricePrivate PriceSunshine PriceKeebler PriceNabisco;
 array chosen_feature[4] FeatPrivate FeatSunshine FeatKeebler FeatNabisco;
 array chosen_display[4] DisplPrivate DisplSunshine DisplKeebler DisplNabisco;
 set crackers_hw5_sampled;
 Subject=_n_;
 do i=1 to 4;
 	Choice=chosen[i];
	Brand=vname(chosen[i]);
	Price=chosen_price[i];
	Feature=chosen_feature[i];
	Display=chosen_display[i];
	output;
end;
run;

proc print data=crackers_hw5_1;
run;

proc logistic data=crackers_hw5_1;
   strata subject;
   class brand (ref='Private') / param=ref;
   model choice (event='1')=feature price display brand brand*display brand*feature;
run;

proc mdc data=crackers_hw5_1;
  id subject;
  class brand;
  model choice=feature price display brand brand*display brand*feature / type=clogit nchoice=4;
  restrict BRANDPrivate=0;
  restrict BRANDPrivateDISPLAY=0;
  restrict BRANDPrivateFEATURE=0;
run;



** appendix
cd "\\storage\homes\S-1-5-21-1167378736-2199707310-2242153877-1063421\Fall 2023\ECON 603\Jorge Replication Exercise"
*** table 1
use sigi_fertility10.dta, clear

reg fertility10 loggdp10, robust 
reg fertility10 loggdp10 sigi, robust 

*** table 3

use dhs.dta,clear

*create variable for difference in fertility intentions 
*(ideal number of children for married men - ideal number of children for married women)
gen diff_ideal = idealnumchild_m_married - idealnumchild_w_married

*code polygny as 0 if missing
gen polygny_all_miss = polygny_all
replace polygny_all_miss = 0 if polygny_all==.
lab var polygny_all_miss "\% Polygny (Missing coded as 0)"

gen polygny_all20 = 1 if polygny_all >20 & polygny_all !=.
replace polygny_all20 = 0 if polygny_all <=20


reg diff_ideal polygny_all, robust
reg diff_ideal polygny_all_miss, robust
reg diff_ideal sigi_value, robust
reg diff_ideal polygny_all sigi_value, robust
reg diff_ideal polygny_all_miss sigi_value, robust
reg diff_ideal polygny_all20 sigi_value, robust


*same thing but with gdp
reg diff_ideal polygny_all lgdp, robust
reg diff_ideal polygny_all_miss lgdp, robust
reg diff_ideal sigi_value lgdp, robust
reg diff_ideal polygny_all sigi_value lgdp, robust
reg diff_ideal polygny_all_miss sigi_value lgdp, robust
reg diff_ideal polygny_all20 sigi_value lgdp, robust


*** table 6


use dhs_microdata.dta, clear
*drop if ideal number of children for women or man is greater than 15
drop if idealnumchild_w >=15 | idealnumchild_m >=15

lab var age_w "Age"
lab var educ_w "Years of education"
lab var child_w "Total children"
lab var idealnumchild_w "Ideal number of children"
lab var idealnumchild_w "Ideal children (woman)"
lab var d1 "Woman has say in own health care"
lab var d2 "Woman has say in large household purchases"
lab var d3 "Woman has say in visits to family or relatives"	
lab var d4 "Woman has say in what to do with money husband earns"

* Explaining difference in ideal number of children by country
foreach c in bf et{
	if "`c'"=="bf"{
		local cname = "Burkina Faso"
	}
	else if "`c'"=="et"{
		local cname = "Ethiopia"
	}
	reg diffideal age_w age_gap educ_gap i.polygny [pw=weight_w] if country=="`cname'" & age_w>=40, robust cluster(hhid)
	reg diffideal age_w age_gap educ_gap i.polygny d1-d4 [pw=weight_w] if country=="`cname'" & age_w>=40, robust cluster(hhid)
	reg diffideal age_w age_gap educ_gap i.polygny index [pw=weight_w] if country=="`cname'" & age_w>=40, robust cluster(hhid)
	reg diffideal age_w age_gap educ_gap i.polygny work_w [pw=weight_w] if country=="`cname'" & age_w>=40, robust cluster(hhid)
	reg diffideal age_w age_gap educ_gap i.polygny work_w index [pw=weight_w] if country=="`cname'" & age_w>=40, robust cluster(hhid)

}

*** tables 7 and 9
* Explaining total number of children
lab var child_w "Total children"
foreach age in 40 45{
	replace educq_w`age' = educq_w`age' - 1
	lab var educq_w`age' "High female education"
	replace age_gapq`age' = age_gapq`age'-1
	lab var age_gapq`age' "High age gap"
	replace educ_gapq`age' = educ_gapq`age'-1
	lab var educ_gapq`age' "High education gap"
	
	foreach c in bf et{
		if "`c'"=="bf"{
			local cname = "Burkina Faso"
		}
		else if "`c'"=="et"{
			local cname = "Ethiopia"
		}

		reg child_w idealnumchild_w idealnumchild_m if age_w >=`age' & country=="`cname'", robust cluster(hhid)
		reg child_w c.idealnumchild_w##i.educq_w`age' c.idealnumchild_m##i.educq_w`age' if age_w >=`age' & country=="`cname'" , robust cluster(hhid)
		reg child_w c.idealnumchild_w##i.age_gapq`age' c.idealnumchild_m##i.age_gapq`age' if age_w >=`age' & country=="`cname'"  , robust cluster(hhid)
		reg child_w c.idealnumchild_w##i.educ_gapq`age' c.idealnumchild_m##i.educ_gapq`age' if age_w >=`age' & country=="`cname'"  , robust cluster(hhid)
		
			
	}
}
*** tables 8 and 10
foreach age in 40 45{
	lab var indexq`age' "High female HH decision index"
	replace indexq`age' = indexq`age'-1
	foreach c in bf et{
		if "`c'"=="bf"{
			local cname = "Burkina Faso"
		}
		else if "`c'"=="et"{
			local cname = "Ethiopia"
		}

		reg child_w idealnumchild_w idealnumchild_m if age_w >=`age' & country=="`cname'", robust cluster(hhid)
		reg child_w c.idealnumchild_w##i.indexq`age' c.idealnumchild_m##i.indexq`age' if age_w >=`age' & country=="`cname'" , robust cluster(hhid)
		reg child_w c.idealnumchild_w##i.work_w c.idealnumchild_m##i.work_w if age_w >=`age' & country=="`cname'"  , robust cluster(hhid)

			
	}
}
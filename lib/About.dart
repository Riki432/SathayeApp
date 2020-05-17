import 'package:flutter/material.dart';
import 'package:flutter_screen_scaler/flutter_screen_scaler.dart';

String para1 = "Parle Tilak Vidyalaya Association’s Sathaye College located in cultural hub of suburbs Vile Parle is a well known College affiliated to University of Mumbai founded in 1959, this Arts, Science College later on added Commerce faculty in 1982, Sociology, Microbiology, Psychology as courses. From 2001 to 2016, new self financing courses like B.Sc(I.T.), B.M.S., B.M.M. along with M.Sc. (I.T.), M.A. in Hindi, M.A. in Buddhist Studies and Ph.D. in Physics and a variety of certificate courses during 2001-2016.";
String para2 = "In 1965 after the sudden demise of Principal C. B. Joshi, Prof. P. M. Potdar, an economist took over as Principal. Under his able guidance the college scaled new heights of glory. A number of new subjects like Microbiology & Statistics were included in the degree college to meet the ever growing demand for job oriented courses. Prof. R. G. Sohoni took over after Principal Potdars’ retirement, who had received ‘Best Teacher Award’ from the Govt. of Maharashtra";
String para3 = " ‘Parle College’ was renamed as ‘Sathaye College’ in 1993 because of the generous contribution from the Sathaye foundation.";
String para4 = "Dr. S. V. Panse took charge as Principal in 1996 and continued to steer the college along the road to progress. When he was appointed as Director Board of College and University Development, University of Mumbai, Dr (Mrs.) Kavita S. Rege was appointed as the Principal in 2001.";
String para5 = "Dr. Kavita Rege started some interesting intercollegiate festivals; giving platform to students to inculcate in them leadership qualities, organisational at skills and interpersonal relations. College was twice accredited by NAAC with ‘A’ grade. College was recognized in 2004 as ‘Best Vocational Institute’ at +2 level. Further University of Mumbai awarded the College in January 2015 as ‘Best College of Mumbai University’ (urban) for year 2013-14. College bagged prestigious ‘Vice-Chancellor’s Banner’ on 25th November 2015 (NCC day) for the excellent work done by our NCC cadets in all these years and particularly in year 2014-15. Parle Tilak Vidyalaya Association founded in 1921, established Parle College now Sathaye College, with a vision to establish an institution of higher learning. This Arts and Science college immediately attracted large number of students and with Principal C. B. Joshi as the founding Principal, the college flourished. He pursued academic excellence relentlessly. Dr. K. S. Nargund, doyen of Organic chemistry put the college name in the research area of chemistry.";
String para6 = "College has its alumni placed in various good positions, who have brought laurels by shining in all walks of life like administrative and foreign services, defence, education, art, film, theatre, sports, dance, music, I.T., media and so on.";
String para7 = "Sathaye College has thus given substance to the vision of its founding fathers: ‘पूर्णता गौरवाय’. Every year hundreds of young people leave its portals equipped not just with degrees, but also with life enhancing skills: therein lies the measures of its success.";


class About extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ScreenScaler scale = ScreenScaler()..init(context);
    return SingleChildScrollView(
      child: Column(
        children : [
        Padding(
          padding: scale.getPaddingAll(10),
          child: Image.asset("assets/college.jpeg"),
        ),
        Padding(
          padding: scale.getPaddingAll(10),
          child: Text(para1),
        ),
        Padding(
          padding: scale.getPaddingAll(10),
          child: Text(para2),
        ),
        Padding(
          padding: scale.getPaddingAll(10),
          child: Text(para3),
        ),
        Padding(
          padding: scale.getPaddingAll(10),
          child: Text(para4),
        ),
        Padding(
          padding: scale.getPaddingAll(10),
          child: Text(para5),
        ),
        Padding(
          padding: scale.getPaddingAll(10),
          child: Text(para6),
        ),
        Padding(
          padding: scale.getPaddingAll(10),
          child: Text(para7),
        ),
        ]
      ),
    );
  }
}

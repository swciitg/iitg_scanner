import 'package:flutter/material.dart';

class MyFonts{
  Text largeTitle(text, color){
    return Text(text,style: TextStyle(fontFamily: 'poppins-bold', fontSize: 34, color: color),);
  }

  Text title1(text, color){
    return Text(text,style: TextStyle(fontFamily: 'poppins-semi', fontSize: 22, color: color),);
  }

  Text heading1(text, color){
    return Text(text,style: TextStyle(fontFamily: 'poppins-semi', fontSize: 17, color: color),);
  }

  Text heading2(text, color){
    return Text(text,style: TextStyle(fontFamily: 'poppins-semi', fontSize: 15, color: color),);
  }

  Text body(text, color){
    return Text(text,style: TextStyle(fontFamily: 'raleway', fontSize: 15, color: color),);
  }

  Text subHeadline(text, color){
    return Text(text,style: TextStyle(fontFamily: 'raleway', fontSize: 13, color: color),);
  }

  Text caption(text, color){
    return Text(text,style: TextStyle(fontFamily: 'raleway', fontSize: 11, color: color),);
  }
}
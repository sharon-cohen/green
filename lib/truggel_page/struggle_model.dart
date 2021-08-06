class StruggleModel {

   String title;
   String description1;
   String description2;
   String description3;
   String description4;
   String description5;
   String share;
   String image;
   String petition;
   String donation;
   String image1;
   String image2;
   String image3;
   String image4;
   String image5;
   int Property;
   DateTime time;
   int place;
   StruggleModel(
      {this.place,this.time,this.title, this.petition, this.image, this.share,this.donation,this.description1,this.description2
     ,this.description3,this.description4,this.description5,this.image1,this.image2,this.image3,this.image4,this.image5
      ,this.Property
      });

void setDescription(String des){
  this.description1=des;
}
}
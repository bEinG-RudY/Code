import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:speeches/NewsData.dart';
import 'apicalls.dart';
import 'package:url_launcher/url_launcher.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
    NewsData newsData = NewsData();
  NewsAPI newsAPI = NewsAPI();
  var isLoading = true;
  var selectedCountry ='in';
  var selectedCategory = 'technology';

    save() async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString("selectedCountry", selectedCountry);
      prefs.setString("selectedCategory", selectedCategory);
    }

    read() async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      selectedCategory = prefs.getString("selectedCategory") ?? 'technology';
      selectedCountry = prefs.getString("selectedCountry") ?? 'in';
    }

    getNewsData({country, category}) async {
      newsData.newsDataFromAPI = await newsAPI.getTopHeadlines(country, category);

    setState(() {
      print(newsData.newsDataFromAPI);
      isLoading = false;
    });
  }

    @override
    void initState() {
      read();
      getNewsData(country: selectedCountry, category: selectedCategory);
      super.initState();
    }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

        backgroundColor: Colors.white,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(100),
          child: AppBar(
            actions: [
              IconButton(
                  onPressed: () {
                    showCountryPicker(
                      context: context,
                      showPhoneCode:
                      false, // optional. Shows phone code before the country name.
                      onSelect: (Country country) {
                        print('Select country: ${country.displayName}');
                        setState(() {
                          selectedCountry = country.countryCode;
                          getNewsData(
                              country: selectedCountry, category: selectedCategory);
                          save();
                        });
                      },
                    );
                  },
                  icon: const Icon(Icons.language))
            ],
            centerTitle: true,
            elevation: 0,
            backgroundColor: Colors.white,
            title: Row(
                children: [
                  Text("Flutter",
                    style: TextStyle(fontSize: 24, color: Colors.black),),
                  Text("News", style: TextStyle(fontSize: 24, color: Colors.blue)),

                ],
              ),
          ),
        ),
      body: isLoading == true? Center(child: CircularProgressIndicator()) :  Column(
          children:[
            SizedBox(height: 15,),
            SizedBox(
              height: 150,
            child: ListView.builder(itemBuilder: (context, index) {
              return RoundedImage(src: newsData.newsList[index]["categoryImage"],text: newsData.newsList[index]["categoryText"]);
            },
              itemCount: newsData.newsList.length,
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
            ),
            ),
            SizedBox(
              height: 750,
              child: ListView.builder(
              shrinkWrap: true,
              itemCount: newsData.newsDataFromAPI["articles"].length,
              itemBuilder: (context, index) {
                return newsCard(context, newsData.newsDataFromAPI["articles"][index]);
              },
            ),
            )
          ],

        )
    );
  }
}

// class HomePage extends StatefulWidget {
//   const HomePage({super.key});
//
//
//   @override
//   State<HomePage> createState() => _HomePageState();
// }
//
// class _HomePageState extends State<HomePage> {
//   NewsData newsData = NewsData();
//   NewsAPI newsAPI = NewsAPI();
//   var isLoading = true;
//
//   getNewsData() async{
//     newsData.newsDataFromAPI =  await newsAPI.getTopHeadlines("in", "technology");
//     setState(() {
//       print(newsData.newsDataFromAPI);
//       isLoading = false;
//     });
//   }
//
//   @override
//   void initState() {
//     getNewsData();
//     super.initState();
//   }
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         centerTitle: true,
//         elevation: 0.0,
//         backgroundColor: Colors.white,
//         title: Row(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             const Text(
//               "Flutter",
//               style:
//               TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
//             ),
//             const Text(
//               "News",
//               style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
//             )
//           ],
//         ),
//       ),
//       body: isLoading == true? Center(child: CircularProgressIndicator()) :  Column(
//         children: [
//           SizedBox(
//             height: MediaQuery.of(context).size.height *0.15,
//             width: MediaQuery.of(context).size.width,
//             child: ListView.builder(itemBuilder: (context, index) {
//               return RoundedImage(src: newsData.newsList[index]["categoryImage"],text: newsData.newsList[index]["categoryText"]);
//             },
//               itemCount: newsData.newsList.length,
//               shrinkWrap: true,
//               scrollDirection: Axis.horizontal,
//             ),
//           ),
//           SizedBox(
//             height: MediaQuery.of(context).size.height * 0.71,
//             width: MediaQuery.of(context).size.width,
//             child: ListView.builder(
//               shrinkWrap: true,
//               itemCount: newsData.newsDataFromAPI["articles"].length,
//               itemBuilder: (context, index) {
//                 return newsCard(context, newsData.newsDataFromAPI["articles"][index]);
//               },
//             ),
//           )
//         ],
//       ),
//     );
//   }
// }

Widget RoundedImage({src,text}){
  return Container(
          alignment: Alignment.center,
          width: 230,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(35),
              image: DecorationImage(
                  image: Image.network(
                    "$src",
                    height: 50,
                    width: 40,
                    fit: BoxFit.cover,
                  ).image
              ),
          ),
          child: Center(
            child: Text(
              "$text",
              style: TextStyle(
                  color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
        );
}

Future<void> _launchUrl(url) async {
  if (!await launchUrl(Uri.parse(url))) {
    throw 'Could not launch $url';
  }
}

Widget newsCard(context, news) {
  void openArticle() {
    launchUrl(Uri.parse(news['url']));
  }

  return GestureDetector(
    onTap: () {
      openArticle();
    },
    child: Container(
        height: 400,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15)
        ),
        width: MediaQuery.of(context).size.width,
        child: Card(
          elevation: 0,
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Image.network(
                  "${news['urlToImage']}",
                  height: 300,
                  width: MediaQuery.of(context).size.width,
                  fit: BoxFit.contain,
                ),
                Text(
                  "${news['title']}",
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 25,
                  ),
                ),
                Text("${news['publishedAt']}")
              ],
            ),
          ),
        )),
  );
}
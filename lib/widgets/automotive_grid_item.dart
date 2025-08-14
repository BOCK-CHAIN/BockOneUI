import 'package:flutter/material.dart';

class AutomotiveGridItem extends StatelessWidget {
  const AutomotiveGridItem({
    super.key,
    required this.title,
    required this.height,
    required this.onTap,
  });

  final String title;
  final double height;
  final void Function()? onTap;

  String imageUrl(title)
  {
    switch(title)
    {
      case 'Automotive EV 1': return 'https://storage.googleapis.com/go-to-u-site.appspot.com/news/50546.51170067246.jpg';
      case 'Automotive SPV' : return 'https://www.echelonedge.com/wp-content/uploads/2023/12/5G-Powered-Cars.jpg';
      case '2/3 Wheeler' : return 'https://cdn.unenvironment.org/s3fs-public/2018-11/2-3wheelers.jpg';
      case 'Hyperloop' : return 'https://blog.emb.global/wp-content/uploads/2024/01/Hyperloop-and-High-Speed-Travel-Marketing-Implications-696x390.webp';
      case 'Foods' : return 'https://static.toiimg.com/thumb/114088891/114088891.jpg?height=746&width=420&resizemode=76&imgsize=123356';
      case 'Groceries' : return 'https://www.bankrate.com/2020/08/01170557/How-to-save-money-on-groceries.jpeg?auto=webp&optimize=high&crop=16:9';
      case 'Dining' : return 'https://img.etimg.com/thumb/116863540/116863540.jpg?height=746&width=420&resizemode=76&imgsize=131580';
      case 'Drones' : return 'https://img.freepik.com/premium-photo/innovative-drone-delivery-3d-rendering-with-box-flight-vertical-mobile-wallpaper_795881-33474.jpg';
      case 'Agriculture' : return 'https://www.shutterstock.com/image-photo/lush-rice-paddy-field-neat-600nw-2499404003.jpg';
      case 'BSCR' : return 'https://media.cnn.com/api/v1/images/stellar/prod/200729120845-us-space-rocket-center-restricted.jpg?q=w_3000,h_2000,x_0,y_0,c_fill';
      case 'BSCS' : return 'https://www.nasa.gov/wp-content/uploads/2020/11/iss-7.jpg';
      case 'BSCM' : return 'https://dynamic-media-cdn.tripadvisor.com/media/photo-o/1d/4f/6e/67/caption.jpg?w=900&h=500&s=1';
      case 'BICRT' : return 'https://image-static.collegedunia.com/public/college_data/images/campusimage/1422856449a3.jpg';
      case 'Inertia Nano' : return 'https://i0.wp.com/spacenews.com/wp-content/uploads/2024/01/latitude-zephyr.jpg?fit=2000%2C1125&ssl=1';
      case 'Inertia' : return 'https://www.kdcresource.com/media/chnjtv1y/falcon-9-reusable-rocket.jpg';
      case 'Inertia Mega' : return 'https://i.ytimg.com/vi/P-xiWn4n8JE/hq720.jpg?sqp=-oaymwEhCK4FEIIDSFryq4qpAxMIARUAAAAAGAElAADIQj0AgKJD&rs=AOn4CLDxEh2aEeNUpibP5MbFmOO_mqmK_w';
      case 'Momentum' : return 'https://ids.si.edu/ids/deliveryService?id=NASM-A19700271000-NASM2018-10448-000001&max=900';
      case 'Fully Reusable Rocket' : return 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSQ21qUXZ5p27o0czfQ03A9sKQiet73jXlwrw&s';
      case 'Orventus' : return 'https://irp.cdn-website.com/2b9cb2fc/dms3rep/multi/Depositphotos_2111331_S.jpg';
      case 'BAVT' : return 'https://images.ansys.com/is/image/ansys/iot-autonomous-vehicle-electrification-high-tech?wid=880&fmt=webp&op_usm=0.9,1.0,20,0&fit=constrain,0';
      case 'Zeyon' : return 'https://www.icdrex.com/wp-content/uploads/2025/04/Introduction-to-semiconductors.png';
      case 'Zeyon G90' : return 'https://media.geeksforgeeks.org/wp-content/uploads/20240607155215/5126124-300.jpg';
      case 'Zeyon C90' : return 'https://static1.xdaimages.com/wordpress/wp-content/uploads/wm/2024/01/msi-gpus-8.jpg';
      case 'Zeyon QSC90' : return 'https://cdn.mos.cms.futurecdn.net/CBcmkyZ8v4tAc8PSDcEgvM.jpg';
      case 'Zeyon QPH90' : return 'https://planetmainframe.com/wp-content/uploads/2023/08/Quantum-Computer.jpg';
      case 'CPU' : return 'https://media.geeksforgeeks.org/wp-content/uploads/20240607155215/5126124-300.jpg';
      case 'Eira' : return 'https://nextgeninvent.com/wp-content/uploads/2024/03/Use-Cases-of-Generative-AI-in-Healthcare.png';
      case 'Autonomous Hospital' : return 'https://advinhealthcare.com/wp-content/uploads/2022/12/Types-of-Hospitals-1-1024x683.jpg';
      case 'Typhronex' : return 'https://imageio.forbes.com/blogs-images/sap/files/2017/08/shutterstock_626404406.jpg?height=474&width=711&fit=bounds';
      case 'Pharmaceutical' : return 'https://imageio.forbes.com/specials-images/imageserve/628b8de7a18d8436b8782e88/0x0.jpg?format=jpg&height=600&width=1200&fit=bounds';
      case 'Krysonix' : return 'https://restream.io/blog/content/images/size/w1200/2023/02/streaming-setup-for-beginners.jpg';
      case 'Xorvane' : return 'https://office-setup-ca.com/wp-content/uploads/2023/12/Business-Management.webp';
      case 'Hynorvixx' : return 'https://www.siteuptime.com/blog/wp-content/uploads/2021/05/66b601ba8958136c5df4882da6d62a85.jpeg';
      case 'Bock Nexus' : return 'https://www.eslsca.fr/sites/eslsca.fr/files/styles/img_style_10_9_480/public/images/ARTICLE_Principales-differences-entre-e-business-et-e-commerce_0.png?itok=C65MiDHv';
      case 'Ruviel' : return 'https://bernardmarr.com/wp-content/uploads/2022/02/What-Is-Social-Media-2.0-Simple-Explanation-And-Examples.jpg';
      case 'Chain' : return 'https://blogs.iadb.org/caribbean-dev-trends/wp-content/uploads/sites/34/2017/12/Blockchain1.jpg';
      case 'Browser' : return 'https://bif.telkomuniversity.ac.id/wp-content/uploads/2024/11/Web-Browser-Pengertian-Fungsi-dan-Jenisnya.webp';
      case 'De-Fi' : return 'https://www.idfcfirstbank.com/content/dam/idfcfirstbank/images/blog/mobile-banking/how-new-age-banking-is-transforming-the-banking-industry-717x404.jpg';
      case 'Technical Education' : return 'https://media.licdn.com/dms/image/v2/D5612AQEOcdfgJXP_rQ/article-cover_image-shrink_720_1280/article-cover_image-shrink_720_1280/0/1693383765389?e=2147483647&v=beta&t=BkDUSqqs-L0MNuEBuyNJObG9bOPghZF7MfVBQM-idR0';
      case 'Spiritual Education' : return 'https://media.licdn.com/dms/image/v2/D5612AQG9DXQGAiHV7A/article-cover_image-shrink_600_2000/article-cover_image-shrink_600_2000/0/1702115342013?e=2147483647&v=beta&t=0ewq1_UGyj8-9S46giKOj06nT8SD8fz7KjOH1_Th2U8';
      case 'Air Force' : return 'https://www.eurokidsindia.com/blog/wp-content/uploads/2023/10/indian-air-force-day-870x570.jpg';
      case 'Navy' : return 'https://globalaffairs.org/sites/default/files/styles/wide_lrg/public/2020-11/credit-us-navy-01.jpg?h=d8d1fca9&itok=dOKU6Lgq';
      case 'Army' : return 'https://images.unsplash.com/photo-1522735856-4f1dc00fb0f0?fm=jpg&q=60&w=3000&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Mnx8YXJteSUyMHNvbGRpZXJ8ZW58MHx8MHx8fDA%3D';
      case 'Secret Services' : return 'https://m.media-amazon.com/images/S/pv-target-images/71271ff40b32ff9489fac5776817113605bfea1b3b80aa774a21126d373351d5._SX1080_FMjpg_.jpg';
    }
    return 'https://storage.googleapis.com/go-to-u-site.appspot.com/news/50546.51170067246.jpg';
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      splashColor: Theme.of(context).primaryColor,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        //padding: const EdgeInsets.all(16),
        height: height,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: Colors.purple.shade300
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Stack(
            fit: StackFit.expand,
            children: [
              Image.network(
                imageUrl(title),
                fit: BoxFit.fill,
              ),
              Container(
                color: const Color.fromRGBO(0,0,0,0.4), // Optional: dark overlay for readability
                alignment: Alignment.bottomRight,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 10.0,right: 20.0),
                  child: Text(
                    title,
                    style: Theme.of(context).textTheme.titleLarge!.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

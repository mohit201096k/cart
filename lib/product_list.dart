import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'cart_model.dart';
import 'cart_provider.dart';
import 'cart_screen.dart';
import 'db_helper.dart';
class ProductListScreen extends StatefulWidget {
  const ProductListScreen({Key? key}) : super(key: key);
  @override
  _ProductListScreenState createState() => _ProductListScreenState();
}
class _ProductListScreenState extends State<ProductListScreen> {
  List<String> productName = ['Disk brake' , 'stone' , 'Oil' , 'Timing belt' , 'Tyre' , 'Engine','Hand break',] ;
  List<String> productUnit = ['1 unit' , '1 unit' , '1 unit' , '1 unit' , '1 unit' , '1 unit','1 unit',] ;
  List<int> productPrice = [10, 20 , 30 , 40 , 50, 60 , 70 ] ;
  List<String> productImage = [
    'assets/images/disc brake.png',
    'assets/images/PhotoRoom.png',
    'assets/images/nut bolt.png',
    'assets/images/gear sprocket timing belt.png',
    'assets/images/tyre.png',
    'assets/images/engine.png',
    'assets/images/hand break.png',
  ] ;
  DBHelper? dbHelper = DBHelper();
  @override
  Widget build(BuildContext context) {
    final cart  = Provider.of<CartProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Product List'),
        centerTitle: true,
        actions: [
          InkWell(
            onTap: (){
              Navigator.push(context,MaterialPageRoute(builder: (context) => CartScreen()));
            },
            child: Center(
              child: Badge(
                showBadge: true,
                badgeContent: Consumer<CartProvider>(
                  builder: (context, value , child){
                    return Text(value.getCounter().toString(),style: TextStyle(color: Colors.white));
                  },
                ),
                animationType: BadgeAnimationType.fade,
                animationDuration: Duration(milliseconds: 300),
                child: Icon(Icons.shopping_cart),
              ),
            ),
          ),

          SizedBox(width: 20.0)
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
                itemCount: productName.length,
                itemBuilder: (context, index){
                  return Card(
                    color: Colors.blueGrey.shade200,
                    child: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Image(
                                height: 100,
                                width: 100,
                                image: AssetImage(productImage[index].toString()),
                              ),
                              SizedBox(width: 10,),
                              Expanded(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(productName[index].toString() ,
                                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                                    ),
                                    SizedBox(height: 5,),
                                    Text(productUnit[index].toString() +" "+r"$"+ productPrice[index].toString() ,
                                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                                    ),
                                    SizedBox(height: 5,),
                                    Align(
                                      alignment: Alignment.centerRight,
                                      child: InkWell(
                                        onTap: (){
                                          print(index);
                                          print(index);
                                          print(productName[index].toString());
                                          print( productPrice[index].toString());
                                          print( productPrice[index]);
                                          print('1');
                                          print(productUnit[index].toString());
                                          print(productImage[index].toString());

                                          dbHelper!.insert(
                                              Cart(
                                                  id: index,
                                                  productId: index.toString(),
                                                  productName: productName[index].toString(),
                                                  initialPrice: productPrice[index],
                                                  productPrice: productPrice[index],
                                                  quantity: 1,
                                                  unitTag: productUnit[index].toString(),
                                                  image: productImage[index].toString())
                                          ).then((value){

                                            cart.addTotalPrice(double.parse(productPrice[index].toString()));
                                            cart.addCounter();

                                            final snackBar = SnackBar(backgroundColor: Colors.teal,content: Text('Product is added to cart'), duration: Duration(seconds: 1),);

                                            ScaffoldMessenger.of(context).showSnackBar(snackBar);

                                          }).onError((error, stackTrace){
                                            print("error"+error.toString());
                                            final snackBar = SnackBar(backgroundColor: Colors.red ,content: Text('Product is already added in cart'), duration: Duration(seconds: 1));

                                            ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                          });
                                        },
                                        child:  Container(
                                          height: 35,
                                          width: 100,
                                          decoration: BoxDecoration(
                                              color: Colors.teal,
                                              borderRadius: BorderRadius.circular(5)
                                          ),
                                          child: const Center(
                                            child:  Text('Add to cart' , style: TextStyle(color: Colors.white),),
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                  );
                }),
          ),

        ],
      ),
    );
  }
}



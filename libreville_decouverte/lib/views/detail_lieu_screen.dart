import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/lieu.dart';
import '../controllers/favoris_controller.dart';
import '../controllers/lieux_controller.dart';
import '../utils/constants.dart';
import 'carte_screen.dart';


class DetailLieuScreen extends StatelessWidget {

  final Lieu lieu;


  const DetailLieuScreen({
    super.key,
    required this.lieu,
  });



  @override
  Widget build(BuildContext context) {


    final favorisController =
        context.watch<FavorisController>();

    final lieuxController =
        context.watch<LieuxController>();


    final estFavori =
        favorisController.estFavori(lieu.id);



    final categorie =
        lieuxController.categories
            .where(
              (c) => c.id == lieu.categorieId,
            )
            .toList();



    final nomCategorie =
        categorie.isNotEmpty
            ? categorie.first.nom
            : "Autre";



    return Scaffold(

      body: CustomScrollView(

        slivers: [


          SliverAppBar(

            expandedHeight: 300,

            pinned: true,


            backgroundColor:
                AppColors.vertCanope,


            leading:
                const BackButton(
                  color: Colors.white,
                ),



            actions: [


              IconButton(

                icon: Icon(

                  estFavori
                      ? Icons.favorite
                      : Icons.favorite_border,


                  color:
                      Colors.red,

                ),


                onPressed: (){

                  favorisController
                      .basculerFavori(
                        lieu.id,
                      );

                },

              )

            ],




            flexibleSpace:
                FlexibleSpaceBar(


              background:
                  _imageLieu(),


            ),


          ),





          SliverToBoxAdapter(


            child:
                Padding(


              padding:
                  const EdgeInsets.all(20),


              child:
                  Column(


                crossAxisAlignment:
                    CrossAxisAlignment.start,



                children: [



                  Text(

                    lieu.nom,


                    style:
                        const TextStyle(

                      fontSize:28,

                      fontWeight:
                          FontWeight.bold,

                    ),

                  ),



                  const SizedBox(
                    height:15,
                  ),



                  Chip(

                    label:
                        Text(
                          nomCategorie,
                        ),

                  ),



                  const SizedBox(
                    height:20,
                  ),



                  _section(

                    "Description",

                    lieu.description.isEmpty

                        ? "Aucune description disponible"

                        : lieu.description,

                  ),



                  const SizedBox(
                    height:20,
                  ),




                  _ligneInfo(

                    Icons.access_time,

                    lieu.horaires.isEmpty

                        ? "Horaires non disponibles"

                        : lieu.horaires,

                  ),




                  const SizedBox(
                    height:15,
                  ),




                  _ligneInfo(

                    Icons.location_on,

                    lieu.acces.isEmpty

                        ? "Accès non disponible"

                        : lieu.acces,

                  ),




                  const SizedBox(
                    height:30,
                  ),




                  SizedBox(

                    width:
                        double.infinity,


                    child:
                        ElevatedButton.icon(


                      icon:
                          const Icon(
                            Icons.map,
                          ),



                      label:
                          const Text(
                            "Voir sur la carte",
                          ),



                      onPressed: (){


                        Navigator.push(

                          context,


                          MaterialPageRoute(

                            builder: (_)=>

                                CarteScreen(

                              lieuDestination:
                                  lieu,

                            ),

                          ),

                        );


                      },

                    ),

                  )

                ],

              ),

            ),

          )

        ],

      ),

    );

  }





  Widget _imageLieu(){


    if(lieu.photoUrl.isEmpty){

      return _placeholder();

    }



    if(lieu.photoUrl.startsWith("http")){


      return Image.network(

        lieu.photoUrl,

        fit:
            BoxFit.cover,


        errorBuilder:
            (_, _, _)=>

                _placeholder(),

      );


    }



    return Image.asset(

      lieu.photoUrl,

      fit:
          BoxFit.cover,


      errorBuilder:
          (_, _, _)=>

              _placeholder(),

    );


  }





  Widget _placeholder(){

    return Container(

      color:
          AppColors.vertCanope,


      child:
          const Center(

        child:
            Icon(

          Icons.image_not_supported,

          size:70,

          color:
              Colors.white54,

        ),

      ),

    );

  }





  Widget _section(
      String titre,
      String texte){


    return Column(

      crossAxisAlignment:
          CrossAxisAlignment.start,


      children:[


        Text(

          titre,

          style:
              const TextStyle(

            fontSize:18,

            fontWeight:
                FontWeight.bold,

          ),

        ),



        const SizedBox(
          height:8,
        ),



        Text(

          texte,

          style:
              const TextStyle(

            fontSize:15,

            height:1.5,

          ),

        )


      ],

    );

  }





  Widget _ligneInfo(
      IconData icon,
      String texte){


    return Row(

      crossAxisAlignment:
          CrossAxisAlignment.start,


      children:[


        Icon(
          icon,
          color:
              AppColors.bleuLagune,
        ),



        const SizedBox(
          width:10,
        ),



        Expanded(

          child:
              Text(
                texte,
              ),

        )


      ],

    );

  }

}

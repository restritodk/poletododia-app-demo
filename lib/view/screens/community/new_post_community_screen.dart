import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quill_html_editor/quill_html_editor.dart';
import 'package:untitled/controllers/community_controller.dart';
import 'package:untitled/data/model/enum/archive_type.dart';
import 'package:untitled/util/styles.dart';
import 'package:untitled/view/base/custom_button.dart';
import 'package:untitled/view/base/custom_text_field.dart';
import 'package:untitled/view/screens/Loading_screen.dart';

import '../../../data/model/response/category.dart';

class NewPostCommunityScreen extends StatefulWidget{
  const NewPostCommunityScreen({super.key});

  @override
  State<NewPostCommunityScreen> createState() => _NewPostCommunityScreenState();
}

class _NewPostCommunityScreenState extends State<NewPostCommunityScreen> {
  final titleController = TextEditingController();
  final QuillEditorController controllerContent = QuillEditorController();
  final titleFocus = FocusNode();
  final contentFocus = FocusNode();

  @override
  Widget build(BuildContext context) {
    return LoadingScreen(
        appBar: AppBar(
          title: const Text('Nova postagem'),
          centerTitle: true,
        ),
        child: SingleChildScrollView(
          child: GetBuilder<CommunityController>(builder: (controller){
            return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(),
                  child: Card(
                    color: Colors.white,
                    elevation: 10,
                    child: CustomTextField(
                      controller: titleController,
                      focusNode: titleFocus,
                      nextFocus: contentFocus,
                      capitalization: TextCapitalization.sentences,
                      inputAction: TextInputAction.next,
                      hintText: 'Titulo',
                    ),
                  ),
                ),

                const SizedBox(height: 20,),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Text('Categoria', style: TextStyle(
                      fontSize: 17
                  ),),
                ),
                Container(
                  width: double.maxFinite,
                  padding: const EdgeInsets.symmetric(horizontal: 0),
                  child: Card(
                    color: Colors.white,
                    elevation: 10,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: DropdownButton<Category>(
                        value: controller.category ?? controller.categories.elementAt(0),
                        onChanged: (Category? newValue) async{
                          controller.setCategory(newValue);
                        },
                        items: controller.categories.map<DropdownMenuItem<Category>>((Category? value) {
                          return DropdownMenuItem<Category>(
                            value: value!,
                            child: Text(value.name!),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ),

                ToolBar(
                  toolBarColor: Colors.cyan.shade50,
                  activeIconColor: Colors.green,
                  padding: const EdgeInsets.all(8),
                  iconSize: 20,
                  controller: controllerContent,
                  customButtons: [
                    InkWell(onTap: () {}, child: const Icon(Icons.favorite)),
                    InkWell(onTap: () {}, child: const Icon(Icons.add_circle)),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(),
                  child: Card(
                    color: Colors.white,
                    elevation: 10,
                    child: QuillHtmlEditor(
                      hintText: 'Entre com seu conteúdo',
                      controller: controllerContent,
                      isEnabled: true,
                      minHeight: 300,
                      hintTextAlign: TextAlign.start,
                      padding: const EdgeInsets.only(left: 10, top: 5),
                      hintTextPadding: EdgeInsets.zero,
                      backgroundColor: colorBackground,
                      onFocusChanged: (hasFocus) => debugPrint('has focus $hasFocus'),
                      onTextChanged: (text) => debugPrint('widget text change $text'),
                      onEditorResized: (height) =>
                          debugPrint('Editor resized $height'),
                      onSelectionChanged: (sel) =>
                          debugPrint('${sel.index},${sel.length}'),
                    ),
                  ),
                ),


                const SizedBox(height: 20,),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Text('Tipo de arquivo (Será usado apenas se for incluso arquivo)', style: TextStyle(
                      fontSize: 17
                  ),),
                ),
                Container(
                  width: double.maxFinite,
                  padding: const EdgeInsets.symmetric(horizontal: 0),
                  child: Card(
                    color: Colors.white,
                    elevation: 10,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: DropdownButton<ArchiveType>(
                        value: controller.archiveType,
                        onChanged: (ArchiveType? newValue) async{
                          controller.setArchiveType(newValue);
                        },
                        items: controller.archivesTypes.map<DropdownMenuItem<ArchiveType>>((ArchiveType? value) {
                          return DropdownMenuItem<ArchiveType>(
                            value: value!,
                            child: Text(value.name),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 20,),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Text('Selecione um arquivo', style: TextStyle(
                      fontSize: 17
                  ),),
                ),
                Container(
                  width: double.maxFinite,
                  padding: const EdgeInsets.symmetric(horizontal: 0),
                  child: Card(
                    color: Colors.white,
                    elevation: 10,
                    child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: ListTile(
                          title: Text(controller.archive == null ? 'Nenhum arquivo selecionado' : controller.archive!.name),
                          leading: const Icon(Icons.file_upload_sharp),
                          onTap: () => controller.selectArchive(),
                        )
                    ),
                  ),
                ),

                const SizedBox(height: 20,),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                  child: CustomButton(
                    onPressed: ()async=> controller.onPublish(title: titleController.text.trim(), content: (await controllerContent.getText()).trim())
                    , buttonText: 'Postar',
                    radius: 100,
                  ),
                ),
                const SizedBox(height: 40,),

              ],);
          },),
        ));
  }
}
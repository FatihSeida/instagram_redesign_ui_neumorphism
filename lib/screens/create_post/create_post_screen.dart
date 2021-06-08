import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_instagram/helpers/helpers.dart';
import 'package:flutter_instagram/screens/create_post/cubit/create_post_cubit.dart';
import 'package:flutter_instagram/widgets/widgets.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_cropper/image_cropper.dart';

class CreatePostScreen extends StatelessWidget {
  static const String routeName = '/createPost';

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: NeumorphicAppBar(
          title: Padding(
            padding: const EdgeInsets.only(left: 10.0),
            child: Text('Create Post',
                style: Theme.of(context).textTheme.headline6),
          ),
        ),
        body: BlocConsumer<CreatePostCubit, CreatePostState>(
          listener: (context, state) {
            if (state.status == CreatePostStatus.success) {
              _formKey.currentState.reset();
              context.read<CreatePostCubit>().reset();

              Scaffold.of(context).showSnackBar(
                SnackBar(
                  backgroundColor: Colors.blue,
                  duration: const Duration(seconds: 1),
                  content: const Text('Post Created'),
                ),
              );
            } else if (state.status == CreatePostStatus.error) {
              showDialog(
                context: context,
                builder: (context) =>
                    ErrorDialog(content: state.failure.message),
              );
            }
          },
          builder: (context, state) {
            return SingleChildScrollView(
              child: Column(
                children: [
                  GestureDetector(
                    onTap: () => _selectPostImage(context),
                    child: Container(
                      height: MediaQuery.of(context).size.height / 2,
                      width: double.infinity,
                      color: NeumorphicTheme.baseColor(context),
                      child: state.postImage != null
                          ? Image.file(state.postImage, fit: BoxFit.cover)
                          : const Icon(
                              Icons.image,
                              color: Colors.grey,
                              size: 120.0,
                            ),
                    ),
                  ),
                  if (state.status == CreatePostStatus.submitting)
                    const LinearProgressIndicator(),
                  Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          TextFormField(
                            decoration: InputDecoration(hintText: 'Caption'),
                            onChanged: (value) => context
                                .read<CreatePostCubit>()
                                .captionChanged(value),
                            validator: (value) => value.trim().isEmpty
                                ? 'Caption cannot be empty.'
                                : null,
                          ),
                          const SizedBox(height: 28.0),
                          InkWell(
                            onTap: () => _submitForm(
                              context,
                              state.postImage,
                              state.status == CreatePostStatus.submitting,
                            ),
                            child: Neumorphic(
                              style: NeumorphicStyle(
                                shape: NeumorphicShape.flat,
                                depth: 5,
                                intensity: 0.75,
                                lightSource: LightSource.topLeft,
                                boxShape: NeumorphicBoxShape.roundRect(
                                    BorderRadius.circular(12)),
                              ),
                              child: Container(
                                  decoration: const BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: <Color>[
                                          Color(0xFF0059D6),
                                          Color(0xFF04BFBF),
                                        ],
                                      ),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(12.0))),
                                  padding:
                                      const EdgeInsets.fromLTRB(20, 10, 20, 10),
                                  child: Text(
                                    'Post',
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.sourceSansPro(
                                        fontSize: 20,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  )),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  void _selectPostImage(BuildContext context) async {
    final pickedFile = await ImageHelper.pickImageFromGallery(
      context: context,
      cropStyle: CropStyle.rectangle,
      title: 'Create Post',
    );
    if (pickedFile != null) {
      context.read<CreatePostCubit>().postImageChanged(pickedFile);
    }
  }

  void _submitForm(BuildContext context, File postImage, bool isSubmitting) {
    if (_formKey.currentState.validate() &&
        postImage != null &&
        !isSubmitting) {
      context.read<CreatePostCubit>().submit();
    }
  }
}

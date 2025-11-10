// lib/pages/models_page.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/model_manager.dart';
import '../models/ml_model.dart';

class ModelsPage extends StatelessWidget {
  const ModelsPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Get the ModelManager
    final modelManager = context.watch<ModelManager>();

    // Get the list of models and the currently active one
    final List<MlModel> availableModels = modelManager.availableModels;
    final MlModel activeModel = modelManager.activeModel;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Models'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Select Active Model',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'The selected model will be used for all new identifications on the Home page.',
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 20),

            Expanded(
              child: RadioGroup<MlModel>(
                // 1. move 'groupValue' here
                groupValue: activeModel,

                // 2. move 'onChanged' here
                onChanged: (MlModel? selectedModel) {
                  if (selectedModel != null) {
                    // This calls the .setActiveModel() method
                    // in our manager, which notifies all listeners.
                    modelManager.setActiveModel(selectedModel);
                  }
                },

                // 3. ListView.builder is now a child
                child: ListView.builder(
                  itemCount: availableModels.length,
                  itemBuilder: (context, index) {
                    final model = availableModels[index];

                    return Card(
                      child: RadioListTile<MlModel>(
                        title: Text(model.name),
                        subtitle: Text(
                          'Model: ${model.modelPath}\nLabels: ${model.labelsPath}',
                          style: const TextStyle(color: Colors.grey, fontSize: 12),
                        ),

                        // The 'value' of this tile
                        value: model,


                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
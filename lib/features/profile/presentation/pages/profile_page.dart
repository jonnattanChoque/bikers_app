import 'package:bikers_app/core/ui/helpers/custom_snackbar.dart';
import 'package:bikers_app/core/ui/viewmodels/view_message.dart';
import 'package:bikers_app/core/ui/widgets/editable_label.dart';
import 'package:bikers_app/features/profile/domain/entities/vehicle_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/profile_viewmodel.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<ProfileViewModel>();

    return ChangeNotifierProvider<ProfileViewModel>.value(
      value: viewModel,
      child: Consumer<ProfileViewModel>(
        builder: (context, vm, _) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (vm.message != null && vm.message?.flowType == MessageFlowType.profile) {
              CustomSnackBar.show(
                context,
                message: vm.message!.text,
                type: vm.message!.type,
                icon: vm.message!.icon,
                top: false
              );
              vm.clearMessage();
            }
          });
          
          return GestureDetector(
            onTap: () {
              FocusScopeNode currentFocus = FocusScope.of(context);
              if (!currentFocus.hasPrimaryFocus && currentFocus.focusedChild != null) {
                currentFocus.focusedChild!.unfocus();
              }
            },
            child: Scaffold(
              appBar: AppBar(title: Text('Login')),
              body: Stack(
                children: [
                  GestureDetector(
                    behavior: HitTestBehavior.translucent, // ensure taps on empty areas are detected
                    onTap: () {
                      // Unfocus any focused TextField in the page
                      FocusScope.of(context).unfocus();
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          EditableLabel(
                            initialValue: viewModel.nickname ?? '',
                            onChanged: (newName) {
                              viewModel.updateUsername(newName);
                            },
                          ),
                    
                          const SizedBox(height: 20),
                    
                          const Text(
                            "Mis Motos",
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                          ),
                    
                          const SizedBox(height: 10),
                    
                          // Lista de motos
                          Expanded(
                            child: viewModel.bikes.isEmpty
                                ? const Center(child: Text("Aún no has agregado motos"))
                                : ListView.builder(
                                    itemCount: viewModel.bikes.length,
                                    itemBuilder: (context, index) {
                                      final VehicleModel bike = viewModel.bikes[index];
                                      return Card(
                                        child: ListTile(
                                          title: Text(bike.name),
                                          subtitle: Text(
                                              "${bike.cc}cc - ${bike.year}"),
                                          trailing: IconButton(
                                            icon: const Icon(Icons.edit),
                                            onPressed: () {
                                              // Navegar a editar moto
                                              // TODO: implementar
                                            },
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  if (vm.isLoading)
                  Positioned.fill(
                    child: Container(
                      color: Theme.of(context).colorScheme.surfaceContainer.withAlpha(8),
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    ),
                  ),
                ]
              ),
            ),
          );
        },
      ),
    );
  }
}

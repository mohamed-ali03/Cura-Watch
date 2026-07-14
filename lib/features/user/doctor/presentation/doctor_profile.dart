import 'package:cura_watch/core/api/end_points.dart';
import 'package:cura_watch/core/constants.dart';
import 'package:cura_watch/core/database/cache/cache_helper.dart';
import 'package:cura_watch/core/services/service_locator.dart';
import 'package:cura_watch/core/size_config.dart';
import 'package:cura_watch/core/widgets/my_button.dart';
import 'package:cura_watch/core/widgets/my_text_field.dart';
import 'package:cura_watch/features/user/doctor/bloc/doctor_bloc.dart';
import 'package:cura_watch/features/user/shared/model/doctor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DoctorProfile extends StatefulWidget {
  const DoctorProfile({super.key});

  @override
  State<DoctorProfile> createState() => _DoctorProfileState();
}

class _DoctorProfileState extends State<DoctorProfile> {
  Doctor? doctor;
  final ValueNotifier<bool> isMale = ValueNotifier<bool>(true);
  final ValueNotifier<Map<String, dynamic>> selectedDate =
      ValueNotifier<Map<String, dynamic>>({});

  @override
  void initState() {
    super.initState();
    context.read<DoctorBloc>().add(GetCurrentDoctorEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DoctorBloc, DoctorState>(
      builder: (_, state) {
        if (state is GetCurrentDoctorLoaded) {
          doctor = state.doctor;
        } else if (state is EditDoctorInfoLoaded) {
          doctor = state.doctor;
        } else if (state is DoctorError) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message)));
        }
        return Column(
          children: [
            Row(
              children: [
                Icon(Icons.person),
                SizedBox(width: 16),
                Text(
                  doctor?.fullName ?? 'Loading.....',
                  style: headerTextStyle,
                ),
                Spacer(),

                PopupMenuButton<String>(
                  icon: const Icon(Icons.more_vert),
                  onSelected: (value) {
                    if (value == 'logout') {
                      getIt<CacheHelper>().removeData(key: APIKeys.token);
                      Navigator.pushNamed(context, '/');
                    } else if (value == 'edit') {
                      showEditsheet(context);
                    }
                  },
                  itemBuilder: (context) => [
                    const PopupMenuItem(
                      value: 'edit',
                      child: Row(
                        children: [
                          Icon(Icons.edit),
                          SizedBox(width: 8),
                          Text('Edit Profile'),
                        ],
                      ),
                    ),
                    const PopupMenuItem(
                      value: 'logout',
                      child: Row(
                        children: [
                          Icon(Icons.logout),
                          SizedBox(width: 8),
                          Text('Logout'),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),
            _buildProfileField(
              fieldTitel: 'Phone',
              fieldHint: 'Phone',
              fieldData: doctor?.phoneNumber ?? '01...',
              isEditable: false,
            ),
            const SizedBox(height: 16),

            _buildProfileField(
              fieldTitel: 'Email',
              fieldHint: 'Email',
              fieldData: doctor?.email ?? 'doctor@example.com',
              isEditable: false,
            ),
            const SizedBox(height: 16),
            _buildProfileField(
              fieldTitel: 'Available Hours',
              fieldHint: '',
              fieldData:
                  doctor?.availableHours.entries
                      .map((entry) => '${entry.key}: ${entry.value}')
                      .join('\n') ??
                  '',
              isEditable: false,
              numberOfLines: (doctor?.availableHours.keys.length ?? 1) == 0
                  ? 1
                  : (doctor?.availableHours.keys.length ?? 1),
            ),
          ],
        );
      },
    );
  }

  Widget _buildProfileField({
    required String fieldTitel,
    required String fieldHint,
    String? fieldData,
    TextEditingController? controller,
    required bool isEditable,
    int? numberOfLines,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(fieldTitel, style: subtitleTextStyle),
        MyTextField(
          hintText: fieldHint,
          controller: controller ?? TextEditingController(text: fieldData),
          isEditable: isEditable,
          numberOfRows: numberOfLines ?? 1,
        ),
      ],
    );
  }

  Future<TimeOfDay?> _pickTime(String title) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      helpText: title,
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: const ColorScheme.light(
            primary: Color(0xFF1A2E4A),
            onPrimary: Colors.white,
            onSurface: Color(0xFF1A2E4A),
          ),
        ),
        child: child!,
      ),
    );
    return picked;
  }

  void showEditsheet(BuildContext context) {
    final doctorBloc = context.read<DoctorBloc>();
    isMale.value = doctor?.gender == 'male';
    ValueNotifier<int> avaliableCount = ValueNotifier<int>(
      doctor?.availableHours.keys.length ?? 0,
    );

    final nameController = TextEditingController(text: doctor?.fullName ?? '');
    final phoneController = TextEditingController(
      text: doctor?.phoneNumber ?? '+201234567890',
    );
    final emailController = TextEditingController(
      text: doctor?.email ?? 'mohamed.ali@example.com',
    );

    ValueNotifier<Map<String, dynamic>> avaliable =
        ValueNotifier<Map<String, dynamic>>(doctor?.availableHours ?? {});

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Edit Profile'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildProfileField(
                fieldTitel: 'Name',
                fieldHint: 'Name',
                controller: nameController,
                isEditable: true,
              ),
              const SizedBox(height: 16),

              _buildProfileField(
                fieldTitel: 'Phone',
                fieldHint: 'Phone',
                controller: phoneController,
                isEditable: true,
              ),
              const SizedBox(height: 16),

              _buildProfileField(
                fieldTitel: 'Email',
                fieldHint: 'Email',
                controller: emailController,
                isEditable: true,
              ),
              const SizedBox(height: 16),

              Text('Gender', style: subtitleTextStyle),

              ValueListenableBuilder(
                valueListenable: isMale,
                builder: (context, value, child) => Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: MyButton(
                        text: 'Male',
                        colored: value,
                        onTap: () => isMale.value = true,
                      ),
                    ),
                    SizedBox(width: getIt<SizeConfig>().blockWidth * 2),
                    Expanded(
                      child: MyButton(
                        text: 'Female',
                        colored: !value,
                        onTap: () => isMale.value = false,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Available Hours', style: subtitleTextStyle),
                  IconButton(
                    onPressed: () {
                      avaliableCount.value += 1;
                    },
                    icon: Icon(Icons.add_box),
                  ),
                ],
              ),
              ValueListenableBuilder(
                valueListenable: avaliableCount,
                builder: (_, count, _) {
                  return ValueListenableBuilder(
                    valueListenable: avaliable,
                    builder: (_, avalibleTimes, _) {
                      return Column(
                        // ← Replace ListView.builder
                        mainAxisSize: MainAxisSize.min,
                        children: List.generate(count, (index) {
                          // ← Use List.generate
                          return Column(
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: DropdownButtonFormField<String>(
                                      initialValue: avalibleTimes.keys
                                          .elementAtOrNull(index),
                                      decoration: const InputDecoration(
                                        border: OutlineInputBorder(),
                                      ),
                                      items: const [
                                        DropdownMenuItem(
                                          value: 'sunday',
                                          child: Text('Sun'),
                                        ),
                                        DropdownMenuItem(
                                          value: 'monday',
                                          child: Text('Mon'),
                                        ),
                                        DropdownMenuItem(
                                          value: 'tuesday',
                                          child: Text('Tues'),
                                        ),
                                        DropdownMenuItem(
                                          value: 'wednesday',
                                          child: Text('Wed'),
                                        ),
                                        DropdownMenuItem(
                                          value: 'thursday',
                                          child: Text('Thurs'),
                                        ),
                                        DropdownMenuItem(
                                          value: 'friday',
                                          child: Text('Fri'),
                                        ),
                                        DropdownMenuItem(
                                          value: 'saturday',
                                          child: Text('Sat'),
                                        ),
                                      ],
                                      onChanged: (value) {
                                        if (avaliable.value.containsKey(
                                          value,
                                        )) {
                                          return;
                                        }
                                        avaliable.value = {
                                          ...avaliable.value,
                                          value!: null,
                                        };
                                      },
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  InkWell(
                                    onTap: () async {
                                      final startTime = await _pickTime(
                                        'Select Start Time',
                                      );
                                      final endTime = await _pickTime(
                                        'Select End Time',
                                      );
                                      if (startTime != null &&
                                          endTime != null &&
                                          index < avalibleTimes.keys.length) {
                                        avaliable.value = {
                                          ...avaliable.value,
                                          avalibleTimes.keys.elementAt(
                                            index,
                                          ): '${startTime.hour.toString().padLeft(2, '0')}:${startTime.minute.toString().padLeft(2, '0')} - ${endTime.hour.toString().padLeft(2, '0')}:${endTime.minute.toString().padLeft(2, '0')}',
                                        };
                                      }
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        color: Colors.grey[200],
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Text(
                                        avalibleTimes.values.elementAtOrNull(
                                                  index,
                                                ) !=
                                                null
                                            ? avalibleTimes.values.elementAt(
                                                index,
                                              )
                                            : 'Pick time',
                                      ),
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      if (index < avalibleTimes.keys.length) {
                                        final updated =
                                            Map<String, dynamic>.from(
                                              avaliable.value,
                                            );
                                        updated.remove(
                                          updated.keys.elementAt(index),
                                        );
                                        avaliable.value = updated;
                                      }
                                      avaliableCount.value -= 1;
                                    },
                                    icon: const Icon(
                                      Icons.delete,
                                      color: Colors.red,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 5),
                            ],
                          );
                        }),
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              doctorBloc.add(
                EditDoctorEvent(
                  fullName: nameController.text == doctor!.fullName
                      ? null
                      : nameController.text,
                  phoneNumber: phoneController.text == doctor!.phoneNumber
                      ? null
                      : phoneController.text,
                  email: emailController.text == doctor!.email
                      ? null
                      : emailController.text,
                  gender: isMale.value == (doctor?.gender == 'male')
                      ? null
                      : isMale.value
                      ? 'male'
                      : 'female',
                  availableHours: Map<String, dynamic>.fromEntries(
                    avaliable.value.entries.where(
                      (entry) => entry.value != null,
                    ),
                  ),
                ),
              );
              Navigator.pop(context);
            },
            child: Text('Edit'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
        ],
      ),
    );
  }
}

/// Thành viên thuộc một hộ gia đình.
class HouseholdMember {
  const HouseholdMember({
    required this.fullName,
    required this.relationship,
    required this.birthYear,
  });

  final String fullName;
  final String relationship;
  final int birthYear;

  HouseholdMember copyWith({
    String? fullName,
    String? relationship,
    int? birthYear,
  }) {
    return HouseholdMember(
      fullName: fullName ?? this.fullName,
      relationship: relationship ?? this.relationship,
      birthYear: birthYear ?? this.birthYear,
    );
  }
}

/// Thông tin sổ hộ khẩu / hộ gia đình của cư dân.
class HouseholdInfo {
  const HouseholdInfo({
    required this.householdCode,
    required this.village,
    required this.headOfHousehold,
    required this.registeredAddress,
    required this.members,
  });

  final String householdCode;
  final String village;
  final String headOfHousehold;
  final String registeredAddress;
  final List<HouseholdMember> members;

  int get memberCount => members.length;

  HouseholdInfo copyWith({
    String? householdCode,
    String? village,
    String? headOfHousehold,
    String? registeredAddress,
    List<HouseholdMember>? members,
  }) {
    return HouseholdInfo(
      householdCode: householdCode ?? this.householdCode,
      village: village ?? this.village,
      headOfHousehold: headOfHousehold ?? this.headOfHousehold,
      registeredAddress: registeredAddress ?? this.registeredAddress,
      members: members ?? this.members,
    );
  }
}

import 'package:airline_management/airplane/Airplane.dart';
import 'package:floor/floor.dart';

@dao
abstract class AirplaneDAO {
  @Query("select max(id)+1 as newid from Airplane")
  Future<int?> getNewAirplaneId();

  @Query("select * from Airplane")
  Future<List<Airplane>> findAllAirplanes();

  @Query("select * from Airplane where id = :id")
  Stream<Airplane?> findAirplaneById(int id);

  @Query("delete from Airplane where id = :id")
  Future<void> deleteAirplaneById(int id);

  @insert
  Future<int> insertAirplane(Airplane airplane);

  @update
  Future<void> updateAirplane(Airplane airplane);
}

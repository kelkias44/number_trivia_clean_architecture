import 'package:clear_architecture/core/network/network_info.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:data_connection_checker/data_connection_checker.dart';


class MockDataConnectionChecker extends Mock 
  implements DataConnectionChecker{
    
}
void main() {
    late MockDataConnectionChecker mockDataConnectionChecker;
    late NetworkInfoImpl networkInfoImpl;

    setUp((){
      mockDataConnectionChecker = MockDataConnectionChecker();
      networkInfoImpl = NetworkInfoImpl(mockDataConnectionChecker);
    });

    group('isConnected', (){
      test('should forward the call to DataConnectionChecker.hasConnection', ()async{
        final tHasConnection = Future.value(true);
        when(mockDataConnectionChecker.hasConnection)
        .thenAnswer((_) => tHasConnection);
        final result = networkInfoImpl.isConnected;
        verify(mockDataConnectionChecker.hasConnection);
        expect(result, tHasConnection);
      });
    });
      
    }
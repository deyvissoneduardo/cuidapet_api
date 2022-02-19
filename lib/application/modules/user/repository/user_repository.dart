import 'package:cuidapet_api/application/database/i_database_connection.dart';
import 'package:cuidapet_api/application/entities/user.dart';
import 'package:cuidapet_api/application/exception/user_exists_exception.dart';
import 'package:cuidapet_api/application/exception/user_notfound_exception.dart';
import 'package:cuidapet_api/application/helpers/crypt_helper.dart';
import 'package:cuidapet_api/application/logger/i_logger.dart';
import 'package:cuidapet_api/application/exception/database_exception.dart';
import 'package:injectable/injectable.dart';
import 'package:mysql1/mysql1.dart';

import './i_user_repository.dart';

@LazySingleton(as: IUserRepository)
class UserRepository implements IUserRepository {
  final IDatabaseConnection connection;
  final ILogger log;

  UserRepository({
    required this.connection,
    required this.log,
  });

  @override
  Future<User> createUser(User user) async {
    MySqlConnection? conn;
    try {
      conn = await connection.openConnection();
      final query = ''' 
        INSERT usuario(email, tipo_cadastro, img_avatar, senha, fornecedor_id, social_id)
        VALUES(?,?,?,?,?,?)
      ''';
      final result = await conn.query(query, [
        user.email,
        user.registerType,
        user.imageAvatar,
        CryptHelper.generateSha256Hash(user.password ?? ''),
        user.supplierId,
        user.socialKey,
      ]);

      final userId = result.insertId;
      return user.copyWith(id: userId, password: null);
    } on MySqlException catch (e, s) {
      if (e.message.contains('usuario.email_UNIQUE')) {
        log.error('Usuario ja cadastrado no banco', e, s);
        throw UserExistsException();
      }
      log.error('Erro ao criar usuario', e, s);
      throw DatabaseException(
        message: 'Erro ao criar usuario no banco',
        exception: e,
      );
    } finally {
      conn?.close();
    }
  }

  @override
  Future<User> loginWithEmailAndPassword(
      String email, String password, bool supplierUser) async {
    MySqlConnection? conn;
    try {
      conn = await connection.openConnection();
      var query = ''' 
        SELECT * FROM usuario 
        WHERE email = ?
        AND senha = ?
      ''';

      if (supplierUser) {
        query += ' AND fornecedor_id IS NOT NULL';
      } else {
        query += ' AND fornecedor_id IS NULL';
      }

      final result = await conn.query(query, [
        email,
        CryptHelper.generateSha256Hash(password),
      ]);

      if (result.isEmpty) {
        log.error('Usuario ou senha invaldo');
        throw UserNotfoundException(message: 'Usuario ou senha invaldo');
      } else {
        final userSqlData = result.first;
        return User(
          id: userSqlData['id'] as int,
          email: userSqlData['email'],
          password: (userSqlData['senha'] as Blob?).toString(),
          registerType: userSqlData['tipo_usuaro'],
          iosToken: (userSqlData['ios_token'] as Blob?).toString(),
          androidToken: (userSqlData['android_token'] as Blob?).toString(),
          refreshToken: (userSqlData['refresh_token'] as Blob?).toString(),
          imageAvatar: (userSqlData['img_avatar'] as Blob?).toString(),
          supplierId: userSqlData['fornecedor_id'],
        );
      }
    } on MySqlException catch (e, s) {
      log.error('Erro ao logar usuario', e, s);
      throw DatabaseException(
        message: e.message,
        exception: e,
      );
    } finally {
      await conn?.close();
    }
  }

  @override
  Future<User> loginByEmailSocialKey(
      String email, String socialKey, String socialType) async {
    MySqlConnection? conn;
    try {
      conn = await connection.openConnection();
      var query = ''' 
        SELECT * FROM 
        usuario WHERE email = ?
      ''';
      final result = await conn.query(query, [email]);

      if (result.isEmpty) {
        throw UserNotfoundException(message: 'Usuario nao encontrado');
      } else {
        final dataMysql = result.first;
        if (dataMysql['social_id'] == null ||
            dataMysql['social_id'] != socialKey) {
          await conn.query(
            ''' 
          UPDATE usuario
          SET social_id = ?,
              tipo_cadastro = ?
          WHERE id = ? 
          ''',
            [socialKey, socialType, dataMysql['id']],
          );
        }
        return User(
          id: dataMysql['id'] as int,
          email: dataMysql['email'],
          password: (dataMysql['senha'] as Blob?).toString(),
          registerType: dataMysql['tipo_usuaro'],
          iosToken: (dataMysql['ios_token'] as Blob?).toString(),
          androidToken: (dataMysql['android_token'] as Blob?).toString(),
          refreshToken: (dataMysql['refresh_token'] as Blob?).toString(),
          imageAvatar: (dataMysql['img_avatar'] as Blob?).toString(),
          supplierId: dataMysql['fornecedor_id'],
        );
      }
    } on MySqlException catch (e, s) {
      log.error('Erro ao cadastra com rede social', e, s);
      throw DatabaseException(
        message: e.message,
        exception: e,
      );
    } finally {
      await conn?.close();
    }
  }

  @override
  Future<void> updateUserDeviceTokenAndRefreshToken(User user) async {
    MySqlConnection? conn;

    try {
      conn = await connection.openConnection();
      final setParams = {};
      if (user.iosToken != null) {
        setParams.putIfAbsent('ios_token', () => user.iosToken);
      } else {
        setParams.putIfAbsent('android_token', () => user.androidToken);
      }

      final query = ''' 
      UPDATE usuario
      SET ${setParams.keys.elementAt(0)} = ?,
        refresh_token = ?
      WHERE id = ?
      ''';

      await conn.query(query, [
        setParams.values.elementAt(0),
        user.refreshToken!,
        user.id!,
      ]);
    } on MySqlException catch (e, s) {
      log.error('Erro ao confirma login', e, s);
      throw DatabaseException(
        message: e.message,
        exception: e,
      );
    } finally {
      conn?.close();
    }
  }
}

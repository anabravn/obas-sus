import sqlalchemy
import logging
import time

from ftplib import FTP
from pyreaddbc import read_dbc
from typing import List


ftp_url = 'ftp.datasus.gov.br'
db_url = 'mysql://ontop:ontop@127.0.0.1/dsus'

data = {
        'ABOPR': '/dissemin/publicos/SIASUS/200801_/Dados/',
        'RDPR': '/dissemin/publicos/SIHSUS/200801_/Dados/'
}

years = [21]
months = [1]

data_dir = 'dbc/'


def download_dbc(prefix: str, ftp_path: str, files: List[str]):
    ftp = FTP(ftp_url)  # conecta ao servidor ftp
    ftp.login()  # login anônimo

    # mudança de diretório
    ftp.cwd(ftp_path)

    # faz download de todos os arquivos da lista
    for fname in files:
        logging.info("Fazendo download do arquivo %s", fname)

        with open(data_dir + fname, 'wb') as fp:
            cmd = 'RETR ' + fname
            ftp.retrbinary(cmd, fp.write)

    ftp.quit()


def dbc_to_sql(table_name: str, db_url: str, files: List[str]):
    engine = sqlalchemy.create_engine(db_url)

    # lê todos os arquivos na lista e insere no banco de dados
    for fname in files:
        logging.info("Lendo arquivo %s", fname)

        df = read_dbc(data_dir + fname, "ISO-8859-1")

        logging.info("Inserindo arquivo %s no banco de dados", fname)

        # cria a tabela se ela não existe, ou só insere os novos registros
        df.to_sql(table_name, engine, if_exists="append",
                  index=False, dtype=sqlalchemy.types.VARCHAR(128))


def get_data(prefix, ftp_path):
    start_time = time.time()

    logging.debug("Fazendo download de arquivos %s, dos anos %s e meses %s",
                  prefix, years, months)

    files = []

    # gera lista de arquivos
    for year in years:
        for month in months:
            fname = prefix + '%02d%02d.dbc' % (year, month)
            files.append(fname)

    logging.debug("Lista de arquivos %s: %s", prefix, str(files))

    download_dbc(prefix, ftp_path, files)
    dbc_to_sql(prefix, db_url, files)

    duration = time.time() - start_time
    logging.info("%s finalizado em %d segundos", prefix, duration)


if __name__ == "__main__":
    logging.basicConfig(level=logging.DEBUG, format="%(levelname)s: %(message)s")

    start_time = time.time()

    for prefix, ftp_path in data.items():
        get_data(prefix, ftp_path)

    duration = time.time() - start_time
    logging.info("Tempo total de execução: %d segundos", duration)

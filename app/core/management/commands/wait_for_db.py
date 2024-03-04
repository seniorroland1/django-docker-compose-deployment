from psycopg2 import OperationalError as Psycopg2OpError
import time
from django.core.management.base import BaseCommand
from django.db.utils import OperationalError


class Command(BaseCommand):

    """Django command to wait for database"""

    def handle(self,*args, **operations):
        """Entrypoint for command"""
        self.stdout.write('Waiting for database')
        db_up =False
        while db_up is False:
            try:
                self.check(databases=['default'])
                db_up = True
            except (OperationalError, Psycopg2OpError):
                self.stdout.write('Waiting 1 sec for database')
                db_up = False
                time.sleep(1)
        self.stdout.write('Database ready!')

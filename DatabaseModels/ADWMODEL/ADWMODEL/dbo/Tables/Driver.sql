﻿CREATE TABLE [dbo].[Driver] (
    [PolicyId]                                     INT            NOT NULL,
    [UnitNbr]                                      INT            NOT NULL,
    [PolicyPartyRelationId]                        INT            NOT NULL,
    [PolicyNbr]                                    VARCHAR (16)   NOT NULL,
    [SublineBusinessTypeCd]                        CHAR (1)       NOT NULL,
    [DriverNbr]                                    CHAR (3)       NULL,
    [ClientReferenceNbr]                           CHAR (10)      NULL,
    [AssignedDriverInd]                            CHAR (1)       NULL,
    [PrincipalOperatorCd]                          CHAR (1)       NULL,
    [DriverNm]                                     VARCHAR (100)  NULL,
    [DriverBirthDt]                                DATE           NULL,
    [GenderCd]                                     CHAR (1)       NULL,
    [MaritalStatusCd]                              CHAR (1)       NULL,
    [LicenseNbr]                                   CHAR (25)      NULL,
    [LicenseStateCd]                               CHAR (2)       NULL,
    [MVRCd]                                        CHAR (1)       NULL,
    [MVRReceivedDt]                                DATE           NULL,
    [MVRRequestDt]                                 DATE           NULL,
    [CLUEReportReferenceNbr]                       CHAR (14)      NULL,
    [DriverClassCd]                                CHAR (3)       NULL,
    [ClassOverrideInd]                             CHAR (1)       NULL,
    [DriverTrainingInd]                            CHAR (1)       NULL,
    [OccupationDesc]                               VARCHAR (60)   NULL,
    [BusDriverInd]                                 CHAR (1)       NULL,
    [GovernmentVehicleDriverInd]                   CHAR (1)       NULL,
    [MilitaryDriverInd]                            CHAR (1)       NULL,
    [DefensiveDriverInd]                           CHAR (1)       NULL,
    [GoodStudentInd]                               CHAR (1)       NULL,
    [StateTrooperInd]                              CHAR (1)       NULL,
    [RecertificationPendingInd]                    CHAR (1)       NULL,
    [RecertificationPendingBusDriverInd]           CHAR (1)       NULL,
    [RecertificationBusDriverDt]                   DATE           NULL,
    [RecertificationPendingDefensiveDriverInd]     CHAR (1)       NULL,
    [RecertificationDefensiveDriverDt]             DATE           NULL,
    [RecertificationPendingGoodStudentInd]         CHAR (1)       NULL,
    [RecertificationGoodStudentDt]                 DATE           NULL,
    [RecertificationPendingMilitaryInd]            CHAR (1)       NULL,
    [RecertificationMilitaryDt]                    DATE           NULL,
    [DriveRightDiscountCd]                         CHAR (2)       NULL,
    [DriveRightDiscountDesc]                       VARCHAR (100)  NULL,
    [DriveRightDiscountPct]                        DECIMAL (3, 2) NULL,
    [DriveRightDiscountDt]                         DATE           NULL,
    [DriveRightMobileInd]                          CHAR (1)       NULL,
    [FutureDriveRightDiscountPct]                  DECIMAL (3, 2) NULL,
    [FutureDriveRightDiscountRenewalEligibilityDt] DATE           NULL,
    [EmploymentDesc]                               VARCHAR (255)  NULL,
    [Last5yearimpairmentInd]                       CHAR (1)       NULL,
    [YearsDriverLicencedCnt]                       INT            NULL,
    [MotorcycleLicenseInd]                         CHAR (1)       NULL,
    [UpdatedTmstmp]                                DATETIME2 (7)  NOT NULL,
    [EnrollmentDt]                                 DATETIME2 (7)  NULL,
    [TotalTrips]                                   DECIMAL (5)    NULL,
    [ActivationCd]                                 VARCHAR (10)   NULL,
    [DriverAddedDt]                                DATETIME2 (7)  NULL,
    [ExpirationDt]                                 DATETIME2 (7)  NULL,
    [UserUpdatedId]                                CHAR (8)       NOT NULL,
    [LastActionCd]                                 CHAR (1)       NOT NULL,
    [SourceSystemCd]                               CHAR (2)       NOT NULL,
    CONSTRAINT [PK_Driver] PRIMARY KEY CLUSTERED ([PolicyPartyRelationId] ASC, [PolicyId] ASC, [UnitNbr] ASC) ON [POLICYCD],
    CONSTRAINT [FK_Driver_AutoUnit_01] FOREIGN KEY ([PolicyId], [UnitNbr]) REFERENCES [dbo].[AutoUnit] ([PolicyId], [UnitNbr]),
    CONSTRAINT [FK_Driver_PolicyPartyRelation_01] FOREIGN KEY ([PolicyPartyRelationId]) REFERENCES [dbo].[PolicyPartyRelation] ([PolicyPartyRelationId])
) ON [POLICYCD];


GO
CREATE NONCLUSTERED INDEX [IX_Driver_01]
    ON [dbo].[Driver]([PolicyId] ASC)
    ON [POLICYCI];


BEGIN TRY

BEGIN TRAN;

-- CreateTable
CREATE TABLE [dbo].[Agency] (
    [id] INT NOT NULL IDENTITY(1,1),
    [name] NVARCHAR(1000) NOT NULL,
    [acronym] VARCHAR(16) NOT NULL,
    [logoUrl] NVARCHAR(1000),
    CONSTRAINT [Agency_pkey] PRIMARY KEY ([id]),
    CONSTRAINT [Agency_logoUrl_key] UNIQUE ([logoUrl])
);

-- CreateTable
CREATE TABLE [dbo].[Language] (
    [id] INT NOT NULL IDENTITY(1,1),
    [name] NVARCHAR(1000) NOT NULL,
    CONSTRAINT [Language_pkey] PRIMARY KEY ([id])
);

-- CreateTable
CREATE TABLE [dbo].[LanguageProficiency] (
    [id] INT NOT NULL IDENTITY(1,1),
    [name] NVARCHAR(1000) NOT NULL,
    CONSTRAINT [LanguageProficiency_pkey] PRIMARY KEY ([id])
);

-- CreateTable
CREATE TABLE [dbo].[ProjectLanguageRequirement] (
    [id] INT NOT NULL IDENTITY(1,1),
    [projectId] INT NOT NULL,
    [languageId] INT NOT NULL,
    [languageProficiencyId] INT NOT NULL,
    CONSTRAINT [ProjectLanguageRequirement_pkey] PRIMARY KEY ([id])
);

-- CreateTable
CREATE TABLE [dbo].[ProjectSkill] (
    [id] INT NOT NULL IDENTITY(1,1),
    [name] NVARCHAR(1000) NOT NULL,
    CONSTRAINT [ProjectSkill_pkey] PRIMARY KEY ([id])
);

-- CreateTable
CREATE TABLE [dbo].[StateDeptOffice] (
    [id] INT NOT NULL IDENTITY(1,1),
    [name] NVARCHAR(1000) NOT NULL,
    [breadcrumb] NVARCHAR(1000) NOT NULL,
    CONSTRAINT [StateDeptOffice_pkey] PRIMARY KEY ([id])
);

-- CreateTable
CREATE TABLE [dbo].[Post] (
    [id] INT NOT NULL IDENTITY(1,1),
    [name] NVARCHAR(1000) NOT NULL,
    CONSTRAINT [Post_pkey] PRIMARY KEY ([id])
);

-- CreateTable
CREATE TABLE [dbo].[Country] (
    [id] INT NOT NULL IDENTITY(1,1),
    [name] NVARCHAR(1000) NOT NULL,
    [countryCode] VARCHAR(16) NOT NULL,
    CONSTRAINT [Country_pkey] PRIMARY KEY ([id])
);

-- CreateTable
CREATE TABLE [dbo].[Announcement] (
    [id] INT NOT NULL IDENTITY(1,1),
    [title] NVARCHAR(1000) NOT NULL,
    [content] NVARCHAR(1000),
    [createdAt] DATETIME2 NOT NULL CONSTRAINT [Announcement_createdAt_df] DEFAULT CURRENT_TIMESTAMP,
    [updatedAt] DATETIME2 NOT NULL,
    [isPublished] BIT NOT NULL CONSTRAINT [Announcement_isPublished_df] DEFAULT 0,
    [authorId] INT NOT NULL,
    CONSTRAINT [Announcement_pkey] PRIMARY KEY ([id])
);

-- CreateTable
CREATE TABLE [dbo].[Profile] (
    [id] INT NOT NULL IDENTITY(1,1),
    [bio] NVARCHAR(1000),
    [userId] INT NOT NULL,
    CONSTRAINT [Profile_pkey] PRIMARY KEY ([id]),
    CONSTRAINT [Profile_userId_key] UNIQUE ([userId])
);

-- CreateTable
CREATE TABLE [dbo].[User] (
    [id] INT NOT NULL IDENTITY(1,1),
    [email] NVARCHAR(1000) NOT NULL,
    [phoneNumber] NVARCHAR(1000),
    [role] NVARCHAR(1000) NOT NULL,
    CONSTRAINT [User_pkey] PRIMARY KEY ([id]),
    CONSTRAINT [User_email_key] UNIQUE ([email])
);

-- CreateTable
CREATE TABLE [dbo].[Admin] (
    [id] INT NOT NULL IDENTITY(1,1),
    [userId] INT NOT NULL,
    CONSTRAINT [Admin_pkey] PRIMARY KEY ([id]),
    CONSTRAINT [Admin_userId_key] UNIQUE ([userId])
);

-- CreateTable
CREATE TABLE [dbo].[Mentor] (
    [id] INT NOT NULL IDENTITY(1,1),
    [userId] INT NOT NULL,
    CONSTRAINT [Mentor_pkey] PRIMARY KEY ([id]),
    CONSTRAINT [Mentor_userId_key] UNIQUE ([userId])
);

-- CreateTable
CREATE TABLE [dbo].[CyclePeriod] (
    [id] INT NOT NULL IDENTITY(1,1),
    [name] NVARCHAR(1000) NOT NULL,
    CONSTRAINT [CyclePeriod_pkey] PRIMARY KEY ([id]),
    CONSTRAINT [CyclePeriod_name_key] UNIQUE ([name])
);

-- CreateTable
CREATE TABLE [dbo].[ProjectStatus] (
    [id] INT NOT NULL IDENTITY(1,1),
    [name] NVARCHAR(1000) NOT NULL,
    CONSTRAINT [ProjectStatus_pkey] PRIMARY KEY ([id]),
    CONSTRAINT [ProjectStatus_name_key] UNIQUE ([name])
);

-- CreateTable
CREATE TABLE [dbo].[ProjectMentors] (
    [projectId] INT NOT NULL,
    [mentorId] INT NOT NULL,
    CONSTRAINT [ProjectMentors_pkey] PRIMARY KEY ([projectId],[mentorId])
);

-- CreateTable
CREATE TABLE [dbo].[Project] (
    [id] INT NOT NULL IDENTITY(1,1),
    [projectCode] NVARCHAR(1000) NOT NULL,
    [isPublished] BIT NOT NULL,
    [countryId] INT NOT NULL,
    [title] NVARCHAR(1000) NOT NULL,
    [slug] NVARCHAR(1000),
    [summary] NVARCHAR(1000) NOT NULL,
    [description] NVARCHAR(1000) NOT NULL,
    [agencyId] INT NOT NULL,
    [stateDeptOfficeId] INT,
    [createdAt] DATETIME2 NOT NULL,
    [updatedAt] DATETIME2 NOT NULL,
    [isExcludedFromReports] BIT NOT NULL CONSTRAINT [Project_isExcludedFromReports_df] DEFAULT 0,
    [cyclePeriodId] INT NOT NULL,
    [projectStatusId] INT NOT NULL,
    [postId] INT,
    [authorId] INT NOT NULL,
    CONSTRAINT [Project_pkey] PRIMARY KEY ([id]),
    CONSTRAINT [Project_projectCode_key] UNIQUE ([projectCode]),
    CONSTRAINT [Project_title_key] UNIQUE ([title]),
    CONSTRAINT [Project_slug_key] UNIQUE ([slug])
);

-- AddForeignKey
ALTER TABLE [dbo].[ProjectLanguageRequirement] ADD CONSTRAINT [ProjectLanguageRequirement_languageId_fkey] FOREIGN KEY ([languageId]) REFERENCES [dbo].[Language]([id]) ON DELETE NO ACTION ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE [dbo].[ProjectLanguageRequirement] ADD CONSTRAINT [ProjectLanguageRequirement_languageProficiencyId_fkey] FOREIGN KEY ([languageProficiencyId]) REFERENCES [dbo].[LanguageProficiency]([id]) ON DELETE NO ACTION ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE [dbo].[ProjectLanguageRequirement] ADD CONSTRAINT [ProjectLanguageRequirement_projectId_fkey] FOREIGN KEY ([projectId]) REFERENCES [dbo].[Project]([id]) ON DELETE NO ACTION ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE [dbo].[Announcement] ADD CONSTRAINT [Announcement_authorId_fkey] FOREIGN KEY ([authorId]) REFERENCES [dbo].[Admin]([id]) ON DELETE NO ACTION ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE [dbo].[Profile] ADD CONSTRAINT [Profile_userId_fkey] FOREIGN KEY ([userId]) REFERENCES [dbo].[User]([id]) ON DELETE NO ACTION ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE [dbo].[Admin] ADD CONSTRAINT [Admin_userId_fkey] FOREIGN KEY ([userId]) REFERENCES [dbo].[User]([id]) ON DELETE NO ACTION ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE [dbo].[Mentor] ADD CONSTRAINT [Mentor_userId_fkey] FOREIGN KEY ([userId]) REFERENCES [dbo].[User]([id]) ON DELETE NO ACTION ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE [dbo].[ProjectMentors] ADD CONSTRAINT [ProjectMentors_mentorId_fkey] FOREIGN KEY ([mentorId]) REFERENCES [dbo].[Mentor]([id]) ON DELETE NO ACTION ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE [dbo].[ProjectMentors] ADD CONSTRAINT [ProjectMentors_projectId_fkey] FOREIGN KEY ([projectId]) REFERENCES [dbo].[Project]([id]) ON DELETE NO ACTION ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE [dbo].[Project] ADD CONSTRAINT [Project_agencyId_fkey] FOREIGN KEY ([agencyId]) REFERENCES [dbo].[Agency]([id]) ON DELETE NO ACTION ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE [dbo].[Project] ADD CONSTRAINT [Project_stateDeptOfficeId_fkey] FOREIGN KEY ([stateDeptOfficeId]) REFERENCES [dbo].[StateDeptOffice]([id]) ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE [dbo].[Project] ADD CONSTRAINT [Project_postId_fkey] FOREIGN KEY ([postId]) REFERENCES [dbo].[Post]([id]) ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE [dbo].[Project] ADD CONSTRAINT [Project_countryId_fkey] FOREIGN KEY ([countryId]) REFERENCES [dbo].[Country]([id]) ON DELETE NO ACTION ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE [dbo].[Project] ADD CONSTRAINT [Project_authorId_fkey] FOREIGN KEY ([authorId]) REFERENCES [dbo].[User]([id]) ON DELETE NO ACTION ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE [dbo].[Project] ADD CONSTRAINT [Project_cyclePeriodId_fkey] FOREIGN KEY ([cyclePeriodId]) REFERENCES [dbo].[CyclePeriod]([id]) ON DELETE NO ACTION ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE [dbo].[Project] ADD CONSTRAINT [Project_projectStatusId_fkey] FOREIGN KEY ([projectStatusId]) REFERENCES [dbo].[ProjectStatus]([id]) ON DELETE NO ACTION ON UPDATE CASCADE;

COMMIT TRAN;

END TRY
BEGIN CATCH

IF @@TRANCOUNT > 0
BEGIN
    ROLLBACK TRAN;
END;
THROW

END CATCH
